class TransaksiModel {
  final String id;
  final String userId;
  final String namaUser;
  final String jenisLayanan; // 'doula' | 'obat' | 'tema' | 'diary_premium'
  final String deskripsi;
  final int nominal;
  final String metodePembayaran;
  final String status; // 'pending' | 'paid' | 'cancelled'
  final String? buktiPembayaran; // URL Firebase Storage
  final DateTime createdAt;
  final DateTime? paidAt;

  TransaksiModel({
    required this.id,
    required this.userId,
    required this.namaUser,
    required this.jenisLayanan,
    required this.deskripsi,
    required this.nominal,
    required this.metodePembayaran,
    required this.status,
    this.buktiPembayaran,
    required this.createdAt,
    this.paidAt,
  });

  factory TransaksiModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return TransaksiModel(
      id: id ?? map['id'] ?? '',
      userId: map['userId'] ?? '',
      namaUser: map['namaUser'] ?? '',
      jenisLayanan: map['jenisLayanan'] ?? '',
      deskripsi: map['deskripsi'] ?? '',
      nominal: (map['nominal'] as num?)?.toInt() ?? 0,
      metodePembayaran: map['metodePembayaran'] ?? '',
      status: map['status'] ?? 'pending',
      buktiPembayaran: map['buktiPembayaran'],
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : DateTime.now(),
      paidAt: map['paidAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['paidAt'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'namaUser': namaUser,
      'jenisLayanan': jenisLayanan,
      'deskripsi': deskripsi,
      'nominal': nominal,
      'metodePembayaran': metodePembayaran,
      'status': status,
      'buktiPembayaran': buktiPembayaran,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'paidAt': paidAt?.millisecondsSinceEpoch,
    };
  }

  TransaksiModel copyWith({String? status, String? buktiPembayaran, DateTime? paidAt}) {
    return TransaksiModel(
      id: id,
      userId: userId,
      namaUser: namaUser,
      jenisLayanan: jenisLayanan,
      deskripsi: deskripsi,
      nominal: nominal,
      metodePembayaran: metodePembayaran,
      status: status ?? this.status,
      buktiPembayaran: buktiPembayaran ?? this.buktiPembayaran,
      createdAt: createdAt,
      paidAt: paidAt ?? this.paidAt,
    );
  }
}
