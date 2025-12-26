import 'package:drift/drift.dart';
import '../db/app_db.dart';
import '../db/daos/sessions_dao.dart';
import '../db/daos/users_dao.dart';
import '../db/daos/books_dao.dart';

class SessionsRepo {
  final AppDb db;
  SessionsRepo(this.db);

  Stream<List<SessionDetails>> watchAll() => db.sessionsDao.watchAllDetails();
  Future<List<User>> users() => db.sessionsDao.getUsers();
  Future<List<Book>> books() => db.sessionsDao.getBooks();

  Future<void> add({
    required int userId,
    required int bookId,
    required DateTime sessionDate,
    int pagesRead = 0,
    int minutes = 0,
    String? note,
  }) async {
    await db.sessionsDao.create(
      ReadingSessionsCompanion.insert(
        userId: userId,
        bookId: bookId,
        sessionDate: sessionDate,
        pagesRead: Value(pagesRead),
        minutes: Value(minutes),
        note: note == null ? const Value.absent() : Value(note),
      ),
    );
  }

  Future<void> update(ReadingSession s) => db.sessionsDao.updateSession(s);
  Future<void> delete(int id) => db.sessionsDao.deleteById(id);
}
