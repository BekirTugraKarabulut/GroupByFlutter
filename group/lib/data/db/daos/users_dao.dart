import 'package:drift/drift.dart';
import '../app_db.dart';
import '../tables.dart';

part 'users_dao.g.dart';

@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<AppDb> with _$UsersDaoMixin {
  UsersDao(AppDb db) : super(db);

  Stream<List<User>> watchAll() => select(users).watch();
  Future<List<User>> getAll() => select(users).get();

  Future<int> create(UsersCompanion data) => into(users).insert(data);
  Future<bool> updateUser(User u) => update(users).replace(u);
  Future<int> deleteById(int id) =>
      (delete(users)..where((t) => t.id.equals(id))).go();
}
