// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'actions_model_a230.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActionsModelAdapter extends TypeAdapter<ActionsModel> {
  @override
  final int typeId = 15;

  @override
  ActionsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActionsModel(
      dateTime: fields[0] as DateTime,
      hobbyModel: fields[1] as HobbyModel,
    );
  }

  @override
  void write(BinaryWriter writer, ActionsModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.dateTime)
      ..writeByte(1)
      ..write(obj.hobbyModel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
