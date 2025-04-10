// lib/models/achievement_model.dart
import 'package:hive/hive.dart';

part 'achievement_a230.g.dart'; // <-- бул сап маанилүү

@HiveType(typeId: 20)
class AchievementModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  bool isUnlocked;

  @HiveField(4)
  DateTime? unlockedAt;
  @HiveField(5)
  bool isShown; // попап чыктыбы же жокпу

  AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    this.isUnlocked = false,
    this.unlockedAt,
    this.isShown = false, // Default value added
  });
}
