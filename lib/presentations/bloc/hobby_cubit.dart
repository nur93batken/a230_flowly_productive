import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:a230_flowly/presentations/models/hobby_model.dart';

class HobbyCubit extends Cubit<List<HobbyModel>> {
  HobbyCubit() : super([]);

  /// Загрузка из Hive при старте
  void loadHobbies() {
    final box = Hive.box<HobbyModel>('hobbies');
    emit(box.values.toList());
  }

  /// Создание (добавление) хобби
  Future<void> addHobby(HobbyModel hobby) async {
    final box = Hive.box<HobbyModel>('hobbies');
    await box.add(hobby);

    // Обновляем состояние
    emit(box.values.toList());
  }

  /// Обновление (по индексу)
  Future<void> updateHobby(int index, HobbyModel updatedHobby) async {
    final box = Hive.box<HobbyModel>('hobbies');
    // putAt обновляет запись с указанным индексом
    await box.putAt(index, updatedHobby);

    // Обновляем состояние
    emit(box.values.toList());
  }

  /// Удаление (по индексу)
  Future<void> deleteHobby(int index) async {
    final box = Hive.box<HobbyModel>('hobbies');
    await box.deleteAt(index);

    // Обновляем состояние
    emit(box.values.toList());
  }
}
