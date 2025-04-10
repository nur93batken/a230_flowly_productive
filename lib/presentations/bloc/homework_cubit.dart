import 'package:a230_flowly/core/notification_service.dart';
import 'package:a230_flowly/presentations/bloc/achievement_cubit.dart';
import 'package:a230_flowly/presentations/models/hobby_model.dart';
import 'package:a230_flowly/presentations/models/user_model.dart';
import 'package:flutter/material.dart';
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
    final achCubit = AchievementCubit();
    achCubit.unlockAchievement('first_step');
    await NotificationService.scheduleNotification(
      id: homework.key ?? 0,
      title: 'Homework Reminder',
      body: '“${homework.title}” is due tomorrow!',
      scheduledDate: DateTime(
        homework.endDate.year,
        homework.endDate.month,
        homework.endDate.day - 1,
        9,
        0,
        0,
      ),
    );

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
    BuildContext context,
  ) async {
    final original = _box.values.firstWhere(
      (h) => h.title == homework.title && h.startDate == homework.startDate,
      orElse: () => throw Exception('Homework not found'),
    );

    original.endDate = newDeadline;
    await original.save();
    loadHomeworks();
    // ignore: use_build_context_synchronously    _checkAchievements(context);
  }

  void updateHomework(
    HomeworkModel updated,
    String title,
    String description,
    HobbyModel hobby,
    DateTime startDate,
    DateTime endDate,
    HomeworkStatus status,
    BuildContext context,
  ) async {
    final original = _box.values.firstWhere(
      (h) => h.title == updated.title && h.startDate == updated.startDate,
      orElse: () => throw Exception('Homework not found'),
    );

    original
      ..title = title
      ..description = description
      ..hobby = hobby
      ..startDate = startDate
      ..endDate = endDate
      ..status = status;

    await original.save();
    loadHomeworks();
    // ignore: use_build_context_synchronously
    _checkAchievements(context);
  }

  void deleteHomework(
    String title,
    String description,
    HobbyModel hobby,
    DateTime startDate,
    DateTime endDate,
    HomeworkStatus status,
    BuildContext context,
  ) async {
    final original = _box.values.firstWhere(
      (h) => h.title == title && h.startDate == startDate,
      orElse: () => throw Exception('Homework not found'),
    );
    original
      ..title = title
      ..description = description
      ..hobby = hobby
      ..startDate = startDate
      ..endDate = endDate
      ..status = status;
    await original.delete();
    loadHomeworks();
    // ignore: use_build_context_synchronously
    _checkAchievements(context);
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

  void checkAchievementsData(BuildContext context) {
    final achievementCubit = context.read<AchievementCubit>();
    final all = _box.values.toList();
    final now = DateTime.now();

    final completed =
        all.where((hw) => hw.status == HomeworkStatus.completed).toList();
    final overdue =
        all.where((hw) => hw.status == HomeworkStatus.overdue).toList();

    final onTime = completed.where((hw) => hw.endDate.isAfter(now)).toList();

    final oneDayBefore =
        completed
            .where(
              (hw) =>
                  hw.endDate.difference(hw.startDate).inDays >= 1 &&
                  hw.endDate.difference(now).inDays == 1,
            )
            .toList();

    final sameDay =
        completed
            .where(
              (hw) =>
                  hw.startDate.day == now.day &&
                  hw.startDate.month == now.month &&
                  hw.startDate.year == now.year,
            )
            .toList();

    final differentHobbies = completed.map((e) => e.hobby.name).toSet().length;

    final tasksPerMonth =
        completed.where((hw) => hw.endDate.month == now.month).toList().length;

    final weeklyPlans =
        all.where((hw) => now.difference(hw.startDate).inDays <= 7).length;

    int calculateAppUsedDays() {
      final userBox = Hive.box<UserModel>('usersBox');
      if (userBox.isEmpty) return 0;

      final user = userBox.values.first;
      final now = DateTime.now();

      return now.difference(user.firstOpenDate).inDays;
    }

    final appUsedDays = calculateAppUsedDays(); // бул кийин эсептелет

    achievementCubit.checkAchievements(
      completedCount: completed.length,
      overdueCount: overdue.length,
      onTimeCount: onTime.length,
      oneDayBeforeCount: oneDayBefore.length,
      sameDayCount: sameDay.length,
      differentHobbiesCount: differentHobbies,
      tasksPerMonth: tasksPerMonth,
      tasksInWeek: weeklyPlans,
      appDaysUsed: appUsedDays,
      withoutDelayCount: onTime.length,
      differentHobbyCount: differentHobbies,
      weeklyPlans: weeklyPlans,
      appUsedDays: appUsedDays,
    );
  }

  void _checkAchievements(BuildContext context) {
    final achievementCubit = context.read<AchievementCubit>();
    final all = _box.values.toList();
    final now = DateTime.now();

    final completed =
        all.where((hw) => hw.status == HomeworkStatus.completed).toList();
    final overdue =
        all.where((hw) => hw.status == HomeworkStatus.overdue).toList();

    final onTime = completed.where((hw) => hw.endDate.isAfter(now)).toList();

    final oneDayBefore =
        completed
            .where(
              (hw) =>
                  hw.endDate.difference(hw.startDate).inDays >= 1 &&
                  hw.endDate.difference(now).inDays == 1,
            )
            .toList();

    final sameDay =
        completed
            .where(
              (hw) =>
                  hw.startDate.day == now.day &&
                  hw.startDate.month == now.month &&
                  hw.startDate.year == now.year,
            )
            .toList();

    final differentHobbies = completed.map((e) => e.hobby.name).toSet().length;

    final tasksPerMonth =
        completed.where((hw) => hw.endDate.month == now.month).toList().length;

    final weeklyPlans =
        all.where((hw) => now.difference(hw.startDate).inDays <= 7).length;

    final appUsedDays = 15; // бул кийин эсептелет

    achievementCubit.checkAchievements(
      completedCount: completed.length,
      overdueCount: overdue.length,
      onTimeCount: onTime.length,
      oneDayBeforeCount: oneDayBefore.length,
      sameDayCount: sameDay.length,
      differentHobbiesCount: differentHobbies,
      tasksPerMonth: tasksPerMonth,
      tasksInWeek: weeklyPlans,
      appDaysUsed: appUsedDays,
      withoutDelayCount: onTime.length,
      differentHobbyCount: differentHobbies,
      weeklyPlans: weeklyPlans,
      appUsedDays: appUsedDays,
    );
  }
}
