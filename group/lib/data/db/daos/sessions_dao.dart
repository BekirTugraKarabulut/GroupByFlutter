import 'package:drift/drift.dart';
import '../app_db.dart';
import '../tables.dart';

part 'sessions_dao.g.dart';

class SessionDetails {
  final ReadingSession session;
  final User user;
  final Book book;
  final Author author;
  SessionDetails(this.session, this.user, this.book, this.author);
}

@DriftAccessor(tables: [ReadingSessions, Users, Books, Authors])
class SessionsDao extends DatabaseAccessor<AppDb> with _$SessionsDaoMixin {
  SessionsDao(AppDb db) : super(db);

  Stream<List<SessionDetails>> watchAllDetails() {
    final q = select(readingSessions).join([
      innerJoin(users, users.id.equalsExp(readingSessions.userId)),
      innerJoin(books, books.id.equalsExp(readingSessions.bookId)),
      innerJoin(authors, authors.id.equalsExp(books.authorId)),
    ]);

    return q.watch().map((rows) {
      return rows.map((r) {
        return SessionDetails(
          r.readTable(readingSessions),
          r.readTable(users),
          r.readTable(books),
          r.readTable(authors),
        );
      }).toList();
    });
  }

  Future<int> create(ReadingSessionsCompanion data) => into(readingSessions).insert(data);
  Future<bool> updateSession(ReadingSession s) => update(readingSessions).replace(s);
  Future<int> deleteById(int id) =>
      (delete(readingSessions)..where((t) => t.id.equals(id))).go();
  Future<List<User>> getUsers() => select(users).get();
  Future<List<Book>> getBooks() => select(books).get();
}
