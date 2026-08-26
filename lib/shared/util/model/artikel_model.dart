class ArtikelModel {
  final String title;
  final String description;
  final String thumbnail;
  final String pubDate;
  final String link;
  final String category;
  final String author;
  final String readTime;
  final String sources;
  final List<String> keyPoints;

  ArtikelModel({
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.pubDate,
    required this.link,
    this.category = 'KESEHATAN IBU',
    this.author = 'Tim Medis Momsie & POGI',
    this.readTime = '5 min baca',
    this.sources = 'Kemenkes RI, WHO, & POGI (Perkumpulan Obstetri dan Ginekologi Indonesia)',
    this.keyPoints = const [],
  });

  factory ArtikelModel.fromMap(Map<String, dynamic> map) {
    return ArtikelModel(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      thumbnail: map['thumbnail'] ?? '',
      pubDate: map['pubDate'] ?? '',
      link: map['link'] ?? '',
      category: map['category'] ?? 'KESEHATAN IBU',
      author: map['author'] ?? 'Tim Medis Momsie & POGI',
      readTime: map['readTime'] ?? '5 min baca',
      sources: map['sources'] ?? 'Kemenkes RI, WHO, & POGI',
      keyPoints: map['keyPoints'] != null ? List<String>.from(map['keyPoints']) : [],
    );
  }

  static ArtikelModel fromJson(Map<String, dynamic> json) =>
      ArtikelModel.fromMap(json);

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      'pubDate': pubDate,
      'link': link,
      'category': category,
      'author': author,
      'readTime': readTime,
      'sources': sources,
      'keyPoints': keyPoints,
    };
  }
}
