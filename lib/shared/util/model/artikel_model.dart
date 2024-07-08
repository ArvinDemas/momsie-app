class ArtikelModel {
  final String title;
  final String content;
  final String imageUrl;
  final String date;
  final String publisher;

  ArtikelModel({
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.date,
    required this.publisher,
  });

  static ArtikelModel fromJson(Map<String, dynamic> json) {
    return ArtikelModel(
      title: json['title'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      date: json['date'],
      publisher: json['publisher'],
    );
  }
}
