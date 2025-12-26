import 'package:drift/drift.dart';
import '../db/app_db.dart';

class UsersRepo {
  final AppDb db;
  UsersRepo(this.db);

  Stream<List<User>> watchAll() => db.usersDao.watchAll();

  Future<void> add(String name, String? email) async {
    await db.usersDao.create(
      UsersCompanion.insert(
        name: name,
        email: email == null ? const Value.absent() : Value(email),
      ),
    );
  }

  Future<void> update(User u) => db.usersDao.updateUser(u);
  Future<void> delete(int id) => db.usersDao.deleteById(id);
}
