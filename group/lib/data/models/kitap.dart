import 'yazar.dart';

class Kitap {
  final String id;
  final String baslik;
  final Yazar yazar;
  final int? yayinYili;
  final String? isbn;
  final String? aciklama;

  Kitap({
    required this.id,
    required this.baslik,
    required this.yazar,
    this.yayinYili,
    this.isbn,
    this.aciklama,
  });

  Kitap copyWith({
    String? id,
    String? baslik,
    Yazar? yazar,
    int? yayinYili,
    String? isbn,
    String? aciklama,
  }) {
    return Kitap(
      id: id ?? this.id,
      baslik: baslik ?? this.baslik,
      yazar: yazar ?? this.yazar,
      yayinYili: yayinYili ?? this.yayinYili,
      isbn: isbn ?? this.isbn,
      aciklama: aciklama ?? this.aciklama,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'baslik': baslik,
      'yazar': yazar.toJson(),
      'yayinYili': yayinYili,
      'isbn': isbn,
      'aciklama': aciklama,
    };
  }

  factory Kitap.fromJson(Map<String, dynamic> json) {
    return Kitap(
      id: json['id'] as String,
      baslik: json['baslik'] as String,
      yazar: Yazar.fromJson(json['yazar'] as Map<String, dynamic>),
      yayinYili: json['yayinYili'] as int?,
      isbn: json['isbn'] as String?,
      aciklama: json['aciklama'] as String?,
    );
  }

  @override
  String toString() =>
      'Kitap(id: $id, baslik: $baslik, yazar: ${yazar.tamAd}, yayinYili: $yayinYili)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Kitap && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
