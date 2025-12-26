import 'package:drift/drift.dart';
import '../db/app_db.dart';
import '../db/daos/books_dao.dart';
import '../db/daos/authors_dao.dart';

class BooksRepo {
  final AppDb db;
  BooksRepo(this.db);

  Stream<List<BookWithAuthor>> watchAll() => db.booksDao.watchAllWithAuthor();
  Future<List<Author>> authors() => db.booksDao.getAuthors();

  Future<void> add({
    required String title,
    required int authorId,
    required int totalPages,
    String? coverPath,
  }) async {
    await db.booksDao.create(
      BooksCompanion.insert(
        title: title,
        authorId: authorId,
        totalPages: Value(totalPages),
        coverPath: coverPath == null ? const Value.absent() : Value(coverPath),
      ),
    );
  }

  Future<void> update(Book b) => db.booksDao.updateBook(b);
  Future<void> delete(int id) => db.booksDao.deleteById(id);
}
