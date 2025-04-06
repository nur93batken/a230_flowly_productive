import 'package:a230_flowly/presentations/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class UserCubit extends Cubit<List<UserModel>> {
  UserCubit() : super([]);

  final Box<UserModel> _box = Hive.box<UserModel>('usersBox');

  /// Загрузка всех пользователей из Hive
  void loadUsers() {
    final users = _box.values.toList();
    emit(users);
  }

  /// Добавление нового пользователя
  Future<void> addUser(String name, String imagePath) async {
    final newUser = UserModel(name, imagePath);
    await _box.add(newUser);
    loadUsers();
  }

  /// Обновление существующего пользователя по индексу
  Future<void> updateUser(int index, String name, String imagePath) async {
    final key = _box.keyAt(index);
    if (key != null) {
      await _box.put(key, UserModel(name, imagePath));
      loadUsers();
    }
  }

  /// Удаление пользователя по индексу
  Future<void> deleteUser(int index) async {
    final key = _box.keyAt(index);
    if (key != null) {
      await _box.delete(key);
      loadUsers();
    }
  }
}
