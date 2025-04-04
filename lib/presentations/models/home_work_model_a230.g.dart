// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_work_model_a230.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HomeworkModelAdapter extends TypeAdapter<HomeworkModel> {
  @override
  final int typeId = 12;

  @override
  HomeworkModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HomeworkModel(
      title: fields[0] as String,
      description: fields[1] as String,
      hobby: fields[2] as HobbyModel,
      startDate: fields[3] as DateTime,
      endDate: fields[4] as DateTime,
      status: fields[5] as HomeworkStatus,
    );
  }

  @override
  void write(BinaryWriter writer, HomeworkModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.hobby)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.endDate)
      ..writeByte(5)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeworkModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HomeworkStatusAdapter extends TypeAdapter<HomeworkStatus> {
  @override
  final int typeId = 13;

  @override
  HomeworkStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HomeworkStatus.atWork;
      case 1:
        return HomeworkStatus.completed;
      case 2:
        return HomeworkStatus.overdue;
      default:
        return HomeworkStatus.atWork;
    }
  }

  @override
  void write(BinaryWriter writer, HomeworkStatus obj) {
    switch (obj) {
      case HomeworkStatus.atWork:
        writer.writeByte(0);
        break;
      case HomeworkStatus.completed:
        writer.writeByte(1);
        break;
      case HomeworkStatus.overdue:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeworkStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
