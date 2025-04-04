import 'package:hive/hive.dart';
part 'category_model.g.dart';

@HiveType(typeId: 1)
class CategoryModel extends HiveObject {
  @HiveField(0)
  final String imagePath;
  @HiveField(1)
  final String title;
  CategoryModel({required this.imagePath, required this.title});
}
