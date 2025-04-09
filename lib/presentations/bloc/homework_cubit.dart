import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../models/home_work_model_a230.dart';
import 'homework_state.dart';

class HomeworkCubit extends Cubit<HomeworkState> {
  HomeworkCubit()
    : super(const HomeworkState(allHomeworks: [], filteredHomeworks: []));

  final _box = Hive.box<HomeworkModel>('homeworks');

  void loadHomeworks() {
    final all =
        _box.values
            .map(
              (hw) => HomeworkModel(
                title: hw.title,
                description: hw.description,
                hobby: hw.hobby,
                startDate: hw.startDate,
                endDate: hw.endDate,
                status: hw.status,
              ),
            )
            .toList();

    final query = state.searchQuery.toLowerCase();
    final filtered =
        query.isEmpty
            ? all
            : all
                .where((hw) => hw.title.toLowerCase().contains(query))
                .toList();

    emit(
      state.copyWith(
        allHomeworks: List.from(all),
        filteredHomeworks: List.from(filtered),
        isSearchActive: query.isNotEmpty,
      ),
    );
  }

  void addHomework(HomeworkModel homework) async {
    await _box.add(homework);
    loadHomeworks();
  }

  void updateHomeworkStatus(
    HomeworkModel homework,
    HomeworkStatus newStatus,
  ) async {
    final original = _box.values.firstWhere(
      (h) => h.title == homework.title && h.startDate == homework.startDate,
      orElse: () => throw Exception('Homework not found'),
    );

    original.status = newStatus;
    await original.save();
    loadHomeworks();
  }

  void updateHomeworkdedline(
    HomeworkModel homework,
    DateTime newDeadline,
  ) async {
    final original = _box.values.firstWhere(
      (h) => h.title == homework.title && h.startDate == homework.startDate,
      orElse: () => throw Exception('Homework not found'),
    );

    original.endDate = newDeadline;
    await original.save();
    loadHomeworks();
  }

  void deleteHomework(int index) async {
    await _box.deleteAt(index);
    loadHomeworks();
  }

  void searchHomeworks(String query) {
    final normalized = query.trim().toLowerCase();

    final filtered =
        state.allHomeworks
            .where((hw) => hw.title.toLowerCase().contains(normalized))
            .toList();

    emit(
      state.copyWith(
        filteredHomeworks: filtered,
        isSearchActive: normalized.isNotEmpty,
        searchQuery: query,
      ),
    );
  }
}
