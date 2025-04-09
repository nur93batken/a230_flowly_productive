import 'package:hive/hive.dart';

import 'package:a230_flowly/presentations/models/category_model.dart';

part 'hobby_model.g.dart';

@HiveType(typeId: 0)
class HobbyModel extends HiveObject {
  @HiveField(0)
  String image;

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

  @HiveField(6)
  String? status;
  @HiveField(7)
  List<String>? progressNotes;

  @HiveField(8)
  List<String> progressImages = [];
  HobbyModel({
    required this.image,
    required this.categoryModel,
    required this.name,
    required this.description,
    required this.startTime,
    required this.endTime,
    this.status = 'In Progress',
    this.progressNotes,
    this.progressImages = const [],
  });

  HobbyModel copyWith({
    String? image,
    String? status,
    CategoryModel? categoryModel,
    String? name,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    List<String>? progressNotes,
    List<String>? progressImages,
  }) {
    return HobbyModel(
      image: image ?? this.image,
      categoryModel: categoryModel ?? this.categoryModel,
      name: name ?? this.name,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      progressNotes: progressNotes ?? this.progressNotes,
      progressImages: progressImages ?? this.progressImages,
    );
  }
}
