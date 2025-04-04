import 'package:a230_flowly/presentations/bloc/homework_state.dart';
import 'package:a230_flowly/presentations/models/home_work_model_a230.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class HomeworkCubit extends Cubit<HomeworkState> {
  HomeworkCubit()
    : super(const HomeworkState(allHomeworks: [], filteredHomeworks: []));

  final _box = Hive.box<HomeworkModel>('homeworks');

  void loadHomeworks() {
    final all = _box.values.toList();
    emit(
      state.copyWith(
        allHomeworks: all,
        filteredHomeworks: all,
        isSearchActive: false,
      ),
    );
  }

  void addHomework(HomeworkModel homework) async {
    await _box.add(homework);
    loadHomeworks();
  }

  void deleteHomework(int index) async {
    await _box.deleteAt(index);
    loadHomeworks();
  }

  void searchHomeworks(String query) {
    if (query.isEmpty) {
      emit(
        state.copyWith(
          filteredHomeworks: state.allHomeworks,
          isSearchActive: false,
        ),
      );
    } else {
      final results =
          state.allHomeworks
              .where(
                (hw) => hw.title.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
      emit(state.copyWith(filteredHomeworks: results, isSearchActive: true));
    }
  }
}
