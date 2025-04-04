import 'package:hive/hive.dart';

part 'hobbi.g.dart';

@HiveType(typeId: 1)
class HobbyModel extends HiveObject {
  @HiveField(0)
  final String name;

  HobbyModel({required this.name});
}
