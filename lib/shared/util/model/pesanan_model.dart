class PesananModel {
  final String pemesan;
  final String tanggal;
  final String jam;
  final String layanan;
  final String harga;
  final String day;
  final String namaUser;
  final String id;

  PesananModel({
    required this.pemesan,
    required this.tanggal,
    required this.day,
    required this.jam,
    required this.layanan,
    required this.harga,
    required this.namaUser,
    required this.id,
  });
}

class ActiveModel {
  final String pemesan;
  final String doula;
  final String tanggal;
  final String jam;
  final String layanan;
  final String harga;
  final String day;
  final String namaUser;
  final String namaDoula;
  final String id;

  ActiveModel({
    required this.pemesan,
    required this.doula,
    required this.tanggal,
    required this.day,
    required this.jam,
    required this.layanan,
    required this.harga,
    required this.namaUser,
    required this.namaDoula,
    required this.id,
  });
}
