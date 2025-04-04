// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hobbi.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HobbyModelAdapter extends TypeAdapter<HobbyModel> {
  @override
  final int typeId = 1;

  @override
  HobbyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HobbyModel(
      name: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HobbyModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.name);
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
