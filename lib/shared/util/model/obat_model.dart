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

  factory ObatModel.fromMap(Map<String, dynamic> map) {
    return ObatModel(
      nama: map['nama'] ?? '',
      image: map['image'] ?? '',
      harga: map['harga']?.toString() ?? '0',
      deskripsi: map['deskripsi'] ?? '',
      jenis: map['jenis'] ?? '',
      noreg: map['noreg'] ?? '',
      aturan: map['aturan'] ?? '',
    );
  }

  // Alias untuk kompatibilitas dengan kode lama
  static ObatModel fromJson(Map<String, dynamic> json) =>
      ObatModel.fromMap(json);

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'image': image,
      'harga': harga,
      'deskripsi': deskripsi,
      'jenis': jenis,
      'noreg': noreg,
      'aturan': aturan,
    };
  }
}
