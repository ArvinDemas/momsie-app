class TokoBayiModel {
  final String alamat;
  final String desc;
  final String nama;
  final String rating;
  final String image;
  final List<dynamic> product;

  TokoBayiModel({
    required this.alamat,
    required this.desc,
    required this.nama,
    required this.rating,
    required this.image,
    required this.product,
  });

  static TokoBayiModel fromJson(Map<String, dynamic> json) {
    return TokoBayiModel(
      alamat: json['alamat'],
      desc: json['desc'],
      nama: json['nama'],
      rating: json['rating'],
      image: json['image'],
      product: json['product'],
    );
  }
}
