import 'package:a230_flowly/presentations/models/hobbi.dart';
import 'package:hive/hive.dart';

part 'home_work_model_a230.g.dart';

@HiveType(typeId: 12)
class HomeworkModel extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final HobbyModel hobby;

  @HiveField(3)
  final DateTime startDate;

  @HiveField(4)
  final DateTime endDate;

  @HiveField(5)
  final HomeworkStatus status;

  HomeworkModel({
    required this.title,
    required this.description,
    required this.hobby,
    required this.startDate,
    required this.endDate,
    required this.status,
  });
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
