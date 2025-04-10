import 'package:a230_flowly/presentations/models/actions_model_a230.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:a230_flowly/presentations/models/hobby_model.dart';

class HobbyCubit extends Cubit<List<HobbyModel>> {
  HobbyCubit() : super([]);

  /// Загрузка из Hive при старте
  Future<void> loadHobbies() async {
    final box = await Hive.openBox<HobbyModel>('hobbies');
    emit(box.values.toList());
  }

  Future<void> loadActions() async {
    final box = await Hive.openBox<HobbyModel>('actions');
    emit(box.values.toList());
  }

  /// Создание (добавление) хобби
  Future<void> addHobby(HobbyModel hobby) async {
    final box = await Hive.openBox<HobbyModel>('hobbies');
    await box.add(hobby);
    final box0 = await Hive.openBox<ActionsModel>('actions');
    final actionModel = ActionsModel(
      dateTime: DateTime.now(),
      hobbyModel: hobby,
    );
    await box0.add(actionModel);
    // Обновляем состояние
    emit(box.values.toList());
    loadActions();
  }

  /// Обновление (по индексу)
  Future<void> updateHobby(int index, HobbyModel updatedHobby) async {
    final box = await Hive.openBox<HobbyModel>('hobbies');
    // putAt обновляет запись с указанным индексом
    await box.putAt(index, updatedHobby);

    // Обновляем состояние
    emit(box.values.toList());
  }

  /// Удаление (по индексу)
  Future<void> deleteHobby(int index) async {
    final box = await Hive.openBox<HobbyModel>('hobbies');
    await box.deleteAt(index);

    // Обновляем состояние
    emit(box.values.toList());
  }

  Future<void> updateHobbyStatus(int index, String status) async {
    final box = Hive.box<HobbyModel>('hobbies');

    // Проверяем, что индекс в пределах допустимого диапазона
    if (index >= 0 && index < box.length) {
      final hobby = box.getAt(index);

      if (hobby != null) {
        hobby.status = status; // Статус обновлен
        await hobby.save(); // Сохраняем изменения в Hive
        emit(box.values.toList()); // Обновляем состояние
      }
    } else {
      print('Ошибка: индекс выходит за пределы диапазона');
    }
  }

  Future<void> updateHobbyProgress(int index, double progress) async {
    final box = await Hive.openBox<HobbyModel>('hobbies');
    final hobby = box.getAt(index);

    // Прогресс жаңыланат
    hobby?.progressNotes?.add("Progress updated to $progress%");
    await hobby?.save();

    emit(box.values.toList()); // Бул жаңыртуу боюнча билдирүү
  }
}
