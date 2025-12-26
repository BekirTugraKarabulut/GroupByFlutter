import 'package:drift/drift.dart';
import '../app_db.dart';
import '../tables.dart';

part 'books_dao.g.dart';

class BookWithAuthor {
  final Book book;
  final Author author;
  BookWithAuthor(this.book, this.author);
}

@DriftAccessor(tables: [Books, Authors])
class BooksDao extends DatabaseAccessor<AppDb> with _$BooksDaoMixin {
  BooksDao(AppDb db) : super(db);

  Stream<List<BookWithAuthor>> watchAllWithAuthor() {
    final q = select(books).join([
      innerJoin(authors, authors.id.equalsExp(books.authorId)),
    ]);

    return q.watch().map((rows) {
      return rows.map((r) {
        return BookWithAuthor(r.readTable(books), r.readTable(authors));
      }).toList();
    });
  }

  Future<int> create(BooksCompanion data) => into(books).insert(data);
  Future<bool> updateBook(Book b) => update(books).replace(b);
  Future<int> deleteById(int id) =>
      (delete(books)..where((t) => t.id.equals(id))).go();
  Future<List<Author>> getAuthors() => select(authors).get();
}
