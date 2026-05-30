class PesananModel {
  final String id;
  final String pemesan;
  final String tanggal;
  final String day;
  final String jam;
  final String layanan;
  final String harga;
  final String namaUser;

  PesananModel({
    required this.id,
    required this.pemesan,
    required this.tanggal,
    required this.day,
    required this.jam,
    required this.layanan,
    required this.harga,
    required this.namaUser,
  });

  factory PesananModel.fromMap(
    Map<String, dynamic> map, {
    String namaUser = '',
  }) {
    return PesananModel(
      id: map['id'] ?? '',
      pemesan: map['user'] ?? '',
      tanggal: map['tanggal'] ?? '',
      day: map['day'] ?? '',
      jam: map['jam'] ?? '',
      layanan: map['layanan'] ?? '',
      harga: map['harga']?.toString() ?? '0',
      namaUser: namaUser,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': pemesan,
      'tanggal': tanggal,
      'day': day,
      'jam': jam,
      'layanan': layanan,
      'harga': harga,
    };
  }
}

class ActiveModel {
  final String id;
  final String pemesan;
  final String doula;
  final String tanggal;
  final String day;
  final String jam;
  final String layanan;
  final String harga;
  final String namaUser;
  final String namaDoula;

  ActiveModel({
    required this.id,
    required this.pemesan,
    required this.doula,
    required this.tanggal,
    required this.day,
    required this.jam,
    required this.layanan,
    required this.harga,
    required this.namaUser,
    required this.namaDoula,
  });

  factory ActiveModel.fromMap(
    Map<String, dynamic> map, {
    String namaUser = '',
    String namaDoula = '',
  }) {
    return ActiveModel(
      id: map['id'] ?? '',
      pemesan: map['user'] ?? '',
      doula: map['doula'] ?? '',
      tanggal: map['tanggal'] ?? '',
      day: map['day'] ?? '',
      jam: map['jam'] ?? '',
      layanan: map['layanan'] ?? '',
      harga: map['harga']?.toString() ?? '0',
      namaUser: namaUser,
      namaDoula: namaDoula,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': pemesan,
      'doula': doula,
      'tanggal': tanggal,
      'day': day,
      'jam': jam,
      'layanan': layanan,
      'harga': harga,
      'namaUser': namaUser,
      'namaDoula': namaDoula,
    };
  }
}
