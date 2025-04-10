import 'package:a230_flowly/core/notification_service.dart';
import 'package:a230_flowly/presentations/bloc/achievement_cubit.dart';
import 'package:a230_flowly/presentations/bloc/hobby_cubit.dart';
import 'package:a230_flowly/presentations/bloc/homework_cubit.dart';
import 'package:a230_flowly/presentations/bloc/user_cubit.dart';
import 'package:a230_flowly/presentations/models/achievement_a230.dart';
import 'package:a230_flowly/presentations/models/category_model.dart';
import 'package:a230_flowly/presentations/models/hobby_model.dart';
import 'package:a230_flowly/presentations/models/home_work_model_a230.dart';
import 'package:a230_flowly/presentations/models/user_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:a230_flowly/presentations/pages/main/splash_screen_flowly.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  tz.initializeTimeZones();
  await NotificationService.initNotifications();

  Hive.registerAdapter(HobbyModelAdapter());
  Hive.registerAdapter(HomeworkStatusAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(HomeworkModelAdapter());
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(AchievementModelAdapter());

  await Hive.openBox<HobbyModel>('hobbies');
  await Hive.openBox<UserModel>('usersBox');
  await Hive.openBox<HomeworkModel>('homeworks');
  await Hive.openBox<CategoryModel>('categories');
  await Hive.openBox<AchievementModel>('achievements');
  await initializeAchievementsIfNeeded();

  //await initializeCategoriesIfNeeded();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeworkCubit()..loadHomeworks()),
        BlocProvider(create: (context) => HobbyCubit()),
        BlocProvider(create: (context) => UserCubit()),
        BlocProvider(create: (_) => AchievementCubit()..loadAchievements()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        child: MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Flowly App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),

          home: SplashScreenFlowly(),
        ),
      ),
    );
  }
}

Future<void> initializeAchievementsIfNeeded() async {
  final box = await Hive.openBox<AchievementModel>('achievements');
  if (box.isEmpty) {
    final defaults = [
      AchievementModel(
        id: 'first_step',
        title: 'First step',
        description: 'Do your first task',
      ),
      AchievementModel(
        id: 'no_delays',
        title: '5 tasks without delays',
        description: 'Complete 5 homework tasks in a row without delinquency',
      ),
      AchievementModel(
        id: 'deadline_pro',
        title: 'Deadline pro',
        description: 'Complete 10 tasks on time',
      ),
      AchievementModel(
        id: 'ninja',
        title: 'Ninja',
        description: 'Close the task 1 day before the deadline',
      ),
      AchievementModel(
        id: 'balance_master',
        title: 'Balance Master',
        description: 'Complete 5 tasks each in 3 different categories',
      ),
      AchievementModel(
        id: 'unstoppable',
        title: 'Unstoppable',
        description: '20 tasks per month',
      ),
      AchievementModel(
        id: 'experimenter',
        title: 'Experimenter',
        description: 'Tie tasks to 10 different hobbies',
      ),
      AchievementModel(
        id: 'record_breaker',
        title: 'Record-breaker',
        description: 'Complete the task with the shortest deadline',
      ),
      AchievementModel(
        id: 'marathoner',
        title: 'Marathoner',
        description: 'Work with the application for 30 days',
      ),
      AchievementModel(
        id: 'rescuer',
        title: 'Rescuer',
        description: 'Complete 5 tasks that have been marked “Overdue”',
      ),
    ];

    if (box.isEmpty) {
      for (final achievement in defaults) {
        await box.add(achievement);
      }
    }
  }
}
