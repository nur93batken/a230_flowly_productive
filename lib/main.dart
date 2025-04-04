import 'package:a230_flowly/presentations/bloc/homework_cubit.dart';
import 'package:a230_flowly/presentations/models/hobbi.dart';
import 'package:a230_flowly/presentations/models/home_work_model_a230.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(HomeworkModelAdapter());
  Hive.registerAdapter(HobbyModelAdapter());
  Hive.registerAdapter(HomeworkStatusAdapter());

  await Hive.openBox<HomeworkModel>('homeworks');
  await Hive.openBox<HobbyModel>('hobbies');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeworkCubit()..loadHomeworks()),
      ],
      child: MaterialApp(
        title: 'Flowly App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const Scaffold(body: Center(child: Text('Hello World'))),
      ),
    );
  }
}
