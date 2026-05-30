class ArtikelModel {
  final String title;
  final String description;
  final String thumbnail;
  final String pubDate;
  final String link;

  ArtikelModel({
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.pubDate,
    required this.link,
  });

  factory ArtikelModel.fromMap(Map<String, dynamic> map) {
    return ArtikelModel(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      thumbnail: map['thumbnail'] ?? '',
      pubDate: map['pubDate'] ?? '',
      link: map['link'] ?? '',
    );
  }

  // Alias untuk kompatibilitas dengan kode lama yang pakai fromJson
  static ArtikelModel fromJson(Map<String, dynamic> json) =>
      ArtikelModel.fromMap(json);

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      'pubDate': pubDate,
      'link': link,
    };
  }
}
