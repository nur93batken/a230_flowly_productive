// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hobby_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HobbyModelAdapter extends TypeAdapter<HobbyModel> {
  @override
  final int typeId = 0;

  @override
  HobbyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HobbyModel(
      image: fields[0] as String,
      categoryModel: fields[1] as CategoryModel,
      name: fields[2] as String,
      description: fields[3] as String,
      startTime: fields[4] as DateTime,
      endTime: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HobbyModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.image)
      ..writeByte(1)
      ..write(obj.categoryModel)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.startTime)
      ..writeByte(5)
      ..write(obj.endTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HobbyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
