import 'package:a230_flowly/presentations/models/hobby_model.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'home_work_model_a230.g.dart';

@HiveType(typeId: 12)
// ignore: must_be_immutable
class HomeworkModel extends HiveObject with EquatableMixin {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  HobbyModel hobby;

  @HiveField(3)
  DateTime startDate;

  @HiveField(4)
  DateTime endDate;

  @HiveField(5)
  HomeworkStatus status;

  HomeworkModel({
    required this.title,
    required this.description,
    required this.hobby,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  @override
  List<Object?> get props => [
    key,
    title,
    description,
    hobby,
    startDate,
    endDate,
    status,
  ];
}

@HiveType(typeId: 13)
enum HomeworkStatus {
  @HiveField(0)
  atWork,

  @HiveField(1)
  completed,

  @HiveField(2)
  overdue,
}
