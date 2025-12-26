import 'package:drift/drift.dart';

import '../db/app_db.dart';
import '../db/daos/authors_dao.dart';

class AuthorsRepo {
  final AppDb db;
  AuthorsRepo(this.db);

  Stream<List<Author>> watchAll() => db.authorsDao.watchAll();

  Future<void> add(String name, String? bio) async {
    await db.authorsDao.create(
      AuthorsCompanion.insert(fullName: name, bio: bio == null ? const Value.absent() : Value(bio)),
    );
  }

  Future<void> update(Author a) => db.authorsDao.updateAuthor(a);
  Future<void> delete(int id) => db.authorsDao.deleteById(id);
}
