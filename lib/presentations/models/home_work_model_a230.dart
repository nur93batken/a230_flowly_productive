import 'package:a230_flowly/presentations/models/hobby_model.dart';
import 'package:hive/hive.dart';

part 'home_work_model_a230.g.dart';

@HiveType(typeId: 12)
class HomeworkModel extends HiveObject {
  @HiveField(0)
  late final String title;

  @HiveField(1)
  late final String description;

  @HiveField(2)
  late final HobbyModel hobby;

  @HiveField(3)
  late final DateTime startDate;

  @HiveField(4)
  late final DateTime endDate;

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
