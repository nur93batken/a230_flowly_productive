import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'user_model.g.dart';

@HiveType(typeId: 2)
class UserModel extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String userImage;
  @HiveField(2)
  DateTime firstOpenDate;

  UserModel(this.name, this.userImage, this.firstOpenDate);
  ImageProvider get imageProvider {
    if (userImage.isEmpty) return const AssetImage('assets/icons/Gallery.png');
    final file = File(userImage);
    return file.existsSync()
        ? FileImage(file)
        : const AssetImage('assets/icons/Gallery.png');
  }
}
