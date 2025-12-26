import 'package:drift/drift.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 2, max: 60)();
  TextColumn get email => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Authors extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fullName => text().withLength(min: 2, max: 80)();
  TextColumn get bio => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Books extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 120)();
  IntColumn get authorId => integer().references(Authors, #id)();
  IntColumn get totalPages => integer().withDefault(const Constant(0))();
  TextColumn get coverPath => text().nullable()(); // image_picker ile seçilen dosya yolu
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class ReadingSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  IntColumn get bookId => integer().references(Books, #id)();
  IntColumn get pagesRead => integer().withDefault(const Constant(0))();
  IntColumn get minutes => integer().withDefault(const Constant(0))();
  DateTimeColumn get sessionDate => dateTime()(); // kullanıcı seçebilir
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
