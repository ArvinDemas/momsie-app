class RumahSakitModel {
  final String nama;
  final double latitude;
  final double longitude;
  final String alamat;
  final String layanan;
  final String rating;
  final String image;

  RumahSakitModel({
    required this.nama,
    required this.latitude,
    required this.longitude,
    required this.alamat,
    required this.layanan,
    required this.rating,
    required this.image,
  });

  factory RumahSakitModel.fromMap(Map<String, dynamic> map) {
    return RumahSakitModel(
      nama: map['nama'] ?? '',
      latitude: double.tryParse(map['latitude']?.toString() ?? '0') ?? 0.0,
      longitude: double.tryParse(map['longitude']?.toString() ?? '0') ?? 0.0,
      alamat: map['alamat'] ?? '',
      layanan: map['layanan'] ?? '',
      rating: map['rating']?.toString() ?? '0',
      image: map['image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'alamat': alamat,
      'layanan': layanan,
      'rating': rating,
      'image': image,
    };
  }
}
