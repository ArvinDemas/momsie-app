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

  factory TokoBayiModel.fromMap(Map<String, dynamic> map) {
    return TokoBayiModel(
      alamat: map['alamat'] ?? '',
      desc: map['desc'] ?? '',
      nama: map['nama'] ?? '',
      rating: map['rating']?.toString() ?? '0',
      image: map['image'] ?? '',
      product: (map['product'] as List<dynamic>?) ?? [],
    );
  }

  // Alias untuk kompatibilitas dengan kode lama
  static TokoBayiModel fromJson(Map<String, dynamic> json) =>
      TokoBayiModel.fromMap(json);

  Map<String, dynamic> toMap() {
    return {
      'alamat': alamat,
      'desc': desc,
      'nama': nama,
      'rating': rating,
      'image': image,
      'product': product,
    };
  }
}
