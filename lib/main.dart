import 'package:a230_flowly/presentations/bloc/hobby_cubit.dart';
import 'package:a230_flowly/presentations/bloc/homework_cubit.dart';
import 'package:a230_flowly/presentations/bloc/user_cubit.dart';
import 'package:a230_flowly/presentations/models/category_model.dart';
import 'package:a230_flowly/presentations/models/hobby_model.dart';
import 'package:a230_flowly/presentations/models/home_work_model_a230.dart';
import 'package:a230_flowly/presentations/models/user_model.dart';

import 'package:a230_flowly/presentations/pages/main/splash_screen_flowly.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(HobbyModelAdapter());
  Hive.registerAdapter(HomeworkStatusAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(HomeworkModelAdapter());
  Hive.registerAdapter(UserModelAdapter());

  await Hive.openBox<HobbyModel>('hobbies');
  await Hive.openBox<CategoryModel>('usersBox');
  await Hive.openBox<HomeworkModel>('homeworks');

  Future<void> initializeCategoriesIfNeeded() async {
    final categoryBox = Hive.box<CategoryModel>('categories');

    if (categoryBox.isEmpty) {
      final defaultCategories = [
        CategoryModel(
          imagePath: 'assets/images/cat2.png',
          title: 'Outdoor sport',
        ),
        CategoryModel(imagePath: 'assets/images/cat1.png', title: 'Science'),
        CategoryModel(imagePath: 'assets/images/cat2.png', title: 'Design'),
        CategoryModel(
          imagePath: 'assets/images/cat3.png',
          title: 'Programming',
        ),
        CategoryModel(imagePath: 'assets/images/cat1.png', title: 'Cooking'),
      ];

      await categoryBox.addAll(defaultCategories);
      print('Default categories initialized');
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeworkCubit()..loadHomeworks()),
        BlocProvider(create: (context) => HobbyCubit()),

        BlocProvider(create: (context) => UserCubit()),
      ],

      child: MaterialApp(
        title: 'Flowly App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: SplashScreenFlowly(),
      ),
    );
  }
}
