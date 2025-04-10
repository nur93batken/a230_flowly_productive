import 'package:a230_flowly/presentations/models/hobby_model.dart';
import 'package:hive/hive.dart';

part 'actions_model_a230.g.dart'; // <-- бул сап маанилүү

@HiveType(typeId: 15)
class ActionsModel extends HiveObject {
  @HiveField(0)
  final DateTime dateTime;

  @HiveField(1)
  final HobbyModel hobbyModel;

  ActionsModel({required this.dateTime, required this.hobbyModel});
}
