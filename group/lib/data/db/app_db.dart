import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:drift/native.dart';
import 'tables.dart';
import 'daos/users_dao.dart';
import 'daos/authors_dao.dart';
import 'daos/books_dao.dart';
import 'daos/sessions_dao.dart';

part 'app_db.g.dart';

@DriftDatabase(
  tables: [Users, Authors, Books, ReadingSessions],
  daos: [UsersDao, AuthorsDao, BooksDao, SessionsDao],
)
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/reading_tracker.sqlite');
    return NativeDatabase(file);
  });
}
