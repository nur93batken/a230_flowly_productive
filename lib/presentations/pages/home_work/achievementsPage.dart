import 'package:a230_flowly/core/app_colors_flowly.dart';
import 'package:a230_flowly/presentations/models/achievement_a230.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../bloc/achievement_cubit.dart';

class AchievementsPage extends StatelessWidget {
  AchievementsPage({super.key});

  final List<AchievementModel> defaultAchievements = [
    AchievementModel(
      id: 'first_step',
      title: 'First Step',
      description: 'Complete your first task',
    ),
    AchievementModel(
      id: 'no_delays',
      title: '5 tasks without delays',
      description: 'Complete 5 tasks on time',
    ),
    AchievementModel(
      id: 'deadline_pro',
      title: 'Deadline Pro',
      description: 'Complete 3 tasks 1 day before deadline',
    ),
    AchievementModel(
      id: 'ninja',
      title: 'Ninja',
      description: 'Complete 3 tasks in one day',
    ),
    AchievementModel(
      id: 'balance_master',
      title: 'Balance Master',
      description: 'Keep balance between 3+ hobbies',
    ),
    AchievementModel(
      id: 'unstoppable',
      title: 'Unstoppable',
      description: 'Complete tasks 7 days in a row',
    ),
    AchievementModel(
      id: 'experimenter',
      title: 'Experimenter',
      description: 'Try 3 different hobbies',
    ),
    AchievementModel(
      id: 'record_breaker',
      title: 'Record Breaker',
      description: 'Plan 10 tasks in one week',
    ),
    AchievementModel(
      id: 'marathoner',
      title: 'Marathoner',
      description: 'Work on long project for 14+ days',
    ),
    AchievementModel(
      id: 'rescuer',
      title: 'Rescuer',
      description: 'Change status of 3 overdue tasks',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsFlowly.backroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(12), // ← Бул бурчту тегеректейт
          ),
          child: AppBar(
            leading: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/arrow.svg',
                width: 24,
                height: 24,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Achievements',
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontFamily: 'Instrument Sans',
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
            titleTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: BlocBuilder<AchievementCubit, List<AchievementModel>>(
        builder: (context, achievements) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: achievements.length,
            itemBuilder: (_, index) {
              final ach = achievements[index];
              return Opacity(
                opacity: ach.isUnlocked ? 1 : 0.56,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/achievements/${ach.id}.png',
                          width: 56.w,
                          height: 56.h,
                        ),
                        8.horizontalSpace,
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ach.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Instrument Sans',
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF181818),
                                ),
                              ),
                              Text(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                ach.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Instrument Sans',
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF181818),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
