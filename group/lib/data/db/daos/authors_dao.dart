import 'package:drift/drift.dart';
import '../app_db.dart';
import '../tables.dart';

part 'authors_dao.g.dart';

@DriftAccessor(tables: [Authors])
class AuthorsDao extends DatabaseAccessor<AppDb> with _$AuthorsDaoMixin {
  AuthorsDao(AppDb db) : super(db);

  Stream<List<Author>> watchAll() => select(authors).watch();
  Future<List<Author>> getAll() => select(authors).get();

  Future<int> create(AuthorsCompanion data) => into(authors).insert(data);
  Future<bool> updateAuthor(Author a) => update(authors).replace(a);
  Future<int> deleteById(int id) =>
      (delete(authors)..where((t) => t.id.equals(id))).go();
}
