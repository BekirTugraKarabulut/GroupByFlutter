class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final DateTime addedDate;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.addedDate,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      description: json['description'] as String,
      addedDate: DateTime.parse(json['addedDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'addedDate': addedDate.toIso8601String(),
    };
  }
}
