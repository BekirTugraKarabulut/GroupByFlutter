class Yazar {
  final String id;
  final String ad;
  final String soyad;
  final int? dogumYili;

  Yazar({
    required this.id,
    required this.ad,
    required this.soyad,
    this.dogumYili,
  });

  String get tamAd => '$ad $soyad';

  Yazar copyWith({String? id, String? ad, String? soyad, int? dogumYili}) {
    return Yazar(
      id: id ?? this.id,
      ad: ad ?? this.ad,
      soyad: soyad ?? this.soyad,
      dogumYili: dogumYili ?? this.dogumYili,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'ad': ad, 'soyad': soyad, 'dogumYili': dogumYili};
  }

  factory Yazar.fromJson(Map<String, dynamic> json) {
    return Yazar(
      id: json['id'] as String,
      ad: json['ad'] as String,
      soyad: json['soyad'] as String,
      dogumYili: json['dogumYili'] as int?,
    );
  }

  @override
  String toString() =>
      'Yazar(id: $id, ad: $ad, soyad: $soyad, dogumYili: $dogumYili)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Yazar && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
