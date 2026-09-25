class DoulaModel {
  final String uid;
  final String image;
  final String name;
  final String job;
  final String alamat;
  final String jenisKelamin;
  final String biografi;
  final String rating;
  final String sertifikasi; // 'Doula Certified' | 'On-going Certified' | 'Non-certified'
  final String email;
  final int saldoTersedia;     // Saldo yang bisa ditarik
  final int saldoEscrow;       // Saldo dalam escrow (belum cair)
  final int totalPendapatan;   // Total pendapatan kumulatif

  DoulaModel({
    required this.uid,
    required this.image,
    required this.name,
    required this.job,
    required this.alamat,
    required this.jenisKelamin,
    required this.biografi,
    this.rating = '',
    this.sertifikasi = 'Doula Certified',
    this.email = '',
    this.saldoTersedia = 0,
    this.saldoEscrow = 0,
    this.totalPendapatan = 0,
  });

  factory DoulaModel.fromMap(Map<String, dynamic> map, {String uid = ''}) {
    return DoulaModel(
      uid: uid,
      image: map['image'] ?? '',
      name: map['name'] ?? 'Mitra',
      job: map['pekerjaan'] ?? map['job'] ?? 'Bidan',
      alamat: map['alamat'] ?? 'Daerah Istimewa Yogyakarta',
      jenisKelamin: map['jenisKelamin'] ?? 'Perempuan',
      biografi: map['biografi'] ?? '',
      rating: map['rating']?.toString() ?? '',
      sertifikasi: map['sertifikasi'] ?? 'Doula Certified',
      email: map['email'] ?? '',
      saldoTersedia: (map['saldo_tersedia'] as num?)?.toInt() ?? 0,
      saldoEscrow: (map['saldo_escrow'] as num?)?.toInt() ?? 0,
      totalPendapatan: (map['totalPendapatan'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'image': image,
      'name': name,
      'pekerjaan': job,
      'alamat': alamat,
      'jenisKelamin': jenisKelamin,
      'biografi': biografi,
      'rating': rating,
      'sertifikasi': sertifikasi,
      'email': email,
      'saldo_tersedia': saldoTersedia,
      'saldo_escrow': saldoEscrow,
      'totalPendapatan': totalPendapatan,
    };
  }
}
