class ObatModel {
  final String nama;
  final String image;
  final String harga;
  final String deskripsi;
  final String jenis;
  final String noreg;
  final String aturan;

  ObatModel({
    required this.nama,
    required this.image,
    required this.harga,
    required this.deskripsi,
    required this.jenis,
    required this.noreg,
    required this.aturan,
  });

  static ObatModel fromJson(Map<String, dynamic> json) {
    return ObatModel(
      nama: json['nama'],
      image: json['image'],
      harga: json['harga'],
      deskripsi: json['deskripsi'],
      jenis: json['jenis'],
      noreg: json['noreg'],
      aturan: json['aturan'],
    );
  }
}
