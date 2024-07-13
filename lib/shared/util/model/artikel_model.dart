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

  static ArtikelModel fromJson(Map<String, dynamic> json) {
    return ArtikelModel(
      title: json['title'],
      description: json['description'],
      thumbnail: json['thumbnail'],
      pubDate: json['pubDate'],
      link: json['link'],
    );
  }
}
