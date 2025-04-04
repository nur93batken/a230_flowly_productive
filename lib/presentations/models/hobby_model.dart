import 'package:a230_flowly/presentations/models/category_model.dart';
import 'package:hive/hive.dart';
part 'hobby_model.g.dart';

@HiveType(typeId: 0)
class HobbyModel extends HiveObject {
  @HiveField(0)
  final String image;
  @HiveField(1)
  final CategoryModel categoryModel;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String description;
  @HiveField(4)
  final DateTime startTime;
  @HiveField(5)
  final DateTime endTime;
  HobbyModel({
    required this.image,
    required this.categoryModel,
    required this.name,
    required this.description,
    required this.startTime,
    required this.endTime,
  });
}
