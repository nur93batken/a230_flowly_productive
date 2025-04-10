import 'package:a230_flowly/presentations/models/achievement_a230.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class AchievementCubit extends Cubit<List<AchievementModel>> {
  AchievementCubit() : super([]);

  final _box = Hive.box<AchievementModel>('achievements');

  void loadAchievements() {
    emit(_box.values.toList());
  }

  void unlockAchievement(String id) async {
    final achievement = _box.values.firstWhere((a) => a.id == id);
    if (!achievement.isUnlocked) {
      achievement.isUnlocked = true;
      achievement.unlockedAt = DateTime.now();
      await achievement.save();
      loadAchievements();
    }
  }

  void checkAchievements({
    required int completedCount,
    required int overdueCount,
    required int onTimeCount,
    required int oneDayBeforeCount,
    required int sameDayCount,
    required int differentHobbiesCount,
    required int tasksPerMonth,
    required int tasksInWeek,
    required int appDaysUsed,
    required int withoutDelayCount,
    required int differentHobbyCount,
    required int weeklyPlans,
    required int appUsedDays,
  }) {
    // 🥇 1. First Step
    if (completedCount >= 1) unlockAchievement('first_step');

    // ⏰ 2. No delays (5 tasks on time)
    if (onTimeCount >= 5) unlockAchievement('no_delays');

    // ⏳ 3. Deadline pro (3 tasks 1 day before deadline)
    if (oneDayBeforeCount >= 3) unlockAchievement('deadline_pro');

    // 🥷 4. Ninja (3 tasks in same day)
    if (sameDayCount >= 3) unlockAchievement('ninja');

    // ⚖️ 5. Balance master (3+ different hobbies)
    if (differentHobbiesCount >= 3) unlockAchievement('balance_master');

    // 🔥 6. Unstoppable (7 күн катары менен тапшырма бүтүрүү)
    if (tasksPerMonth >= 7) unlockAchievement('unstoppable');

    // 🧪 7. Experimenter (3 хоббиден тапшырма)
    if (differentHobbiesCount >= 3) unlockAchievement('experimenter');

    // 🚀 8. Record Breaker (10 пландалган тапшырма бир жумада)
    if (tasksInWeek >= 10) unlockAchievement('record_breaker');

    // 🏁 9. Marathoner (14+ күн колдонуу)
    if (appDaysUsed >= 30) unlockAchievement('marathoner');

    // 🆘 10. Rescuer (3 overdue тапшырманын статусу өзгөргөн)
    if (overdueCount >= 3) unlockAchievement('rescuer');
  }
}
