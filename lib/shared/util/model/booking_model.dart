class BookingModel {
  final String id;
  final String transactionId;
  final String userId;
  final String namaUser;
  final String doulaUid;
  final String doulaName;
  final String doulaPhoto;
  final String doulaJob;
  final String tanggal;
  final String day;
  final String jam;
  final String layanan;
  final String? alamat;
  final String? catatan;
  final int hargaLayanan;
  final int biayaAdmin;
  final int totalBayar;
  final int platformFee; // 15% dari hargaLayanan
  final int doulaEarnings; // 85% dari hargaLayanan
  final String status; // 'pending' | 'paid' | 'confirmed' | 'ongoing' | 'completed' | 'cancelled'
  final DateTime createdAt;
  final String? zoomLink;
  final bool isOnDemand;
  final DateTime? expiredAt;
  final DateTime? paidAt;
  final DateTime? confirmedAt;
  final DateTime? completedAt;

  BookingModel({
    required this.id,
    required this.transactionId,
    required this.userId,
    required this.namaUser,
    required this.doulaUid,
    required this.doulaName,
    required this.doulaPhoto,
    required this.doulaJob,
    required this.tanggal,
    required this.day,
    required this.jam,
    required this.layanan,
    this.alamat,
    this.catatan,
    required this.hargaLayanan,
    required this.biayaAdmin,
    required this.totalBayar,
    required this.platformFee,
    required this.doulaEarnings,
    required this.status,
    required this.createdAt,
    this.zoomLink,
    this.isOnDemand = false,
    this.paidAt,
    this.confirmedAt,
    this.completedAt,
    this.expiredAt,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return BookingModel(
      id: id ?? map['id'] ?? '',
      transactionId: map['transactionId'] ?? '',
      userId: map['userId'] ?? '',
      namaUser: map['namaUser'] ?? '',
      doulaUid: map['doulaUid'] ?? '',
      doulaName: map['doulaName'] ?? '',
      doulaPhoto: map['doulaPhoto'] ?? '',
      doulaJob: map['doulaJob'] ?? '',
      tanggal: map['tanggal'] ?? '',
      day: map['day'] ?? '',
      jam: map['jam'] ?? '',
      layanan: map['layanan'] ?? '',
      alamat: map['alamat'],
      catatan: map['catatan'],
      hargaLayanan: (map['hargaLayanan'] as num?)?.toInt() ?? 0,
      biayaAdmin: (map['biayaAdmin'] as num?)?.toInt() ?? 2000,
      totalBayar: (map['totalBayar'] as num?)?.toInt() ?? 0,
      platformFee: (map['platformFee'] as num?)?.toInt() ?? 0,
      doulaEarnings: (map['doulaEarnings'] as num?)?.toInt() ?? 0,
      status: map['status'] ?? 'pending',
      zoomLink: map['zoomLink'] as String?,
      isOnDemand: map['isOnDemand'] as bool? ?? false,
      createdAt: _parseDateTime(map['createdAt']) ?? DateTime.now(),
      paidAt: _parseDateTime(map['paidAt']),
      confirmedAt: _parseDateTime(map['confirmedAt']),
      completedAt: _parseDateTime(map['completedAt']),
      expiredAt: _parseDateTime(map['expiredAt']),
    );
  }

  /// Parse DateTime dari Firestore Timestamp, int epoch ms, atau String ISO
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    // Firestore Timestamp object
    if (value is Map && value.containsKey('_seconds')) {
      return DateTime.fromMillisecondsSinceEpoch((value['_seconds'] as int) * 1000);
    }
    // cloud_firestore Timestamp class
    try {
      // Timestamp has .toDate()
      final ts = value as dynamic;
      if (ts.toDate != null) return ts.toDate() as DateTime;
    } catch (_) {}
    // int epoch milliseconds
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    // String ISO
    if (value is String) return DateTime.tryParse(value);
    return null;
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'transactionId': transactionId,
      'userId': userId,
      'namaUser': namaUser,
      'doulaUid': doulaUid,
      'doulaName': doulaName,
      'doulaPhoto': doulaPhoto,
      'doulaJob': doulaJob,
      'tanggal': tanggal,
      'day': day,
      'jam': jam,
      'layanan': layanan,
      'alamat': alamat,
      'catatan': catatan,
      'hargaLayanan': hargaLayanan,
      'biayaAdmin': biayaAdmin,
      'totalBayar': totalBayar,
      'platformFee': platformFee,
      'doulaEarnings': doulaEarnings,
      'status': status,
      'zoomLink': zoomLink,
      'isOnDemand': isOnDemand,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'paidAt': paidAt?.millisecondsSinceEpoch,
      'confirmedAt': confirmedAt?.millisecondsSinceEpoch,
      'completedAt': completedAt?.millisecondsSinceEpoch,
      'expiredAt': expiredAt?.millisecondsSinceEpoch,
    };
  }

  BookingModel copyWith({
    String? status,
    DateTime? paidAt,
    DateTime? confirmedAt,
    DateTime? completedAt,
    String? zoomLink,
    bool? isOnDemand,
    DateTime? expiredAt,
  }) {
    return BookingModel(
      id: id,
      transactionId: transactionId,
      userId: userId,
      namaUser: namaUser,
      doulaUid: doulaUid,
      doulaName: doulaName,
      doulaPhoto: doulaPhoto,
      doulaJob: doulaJob,
      tanggal: tanggal,
      day: day,
      jam: jam,
      layanan: layanan,
      alamat: alamat,
      catatan: catatan,
      hargaLayanan: hargaLayanan,
      biayaAdmin: biayaAdmin,
      totalBayar: totalBayar,
      platformFee: platformFee,
      doulaEarnings: doulaEarnings,
      status: status ?? this.status,
      zoomLink: zoomLink ?? this.zoomLink,
      isOnDemand: isOnDemand ?? this.isOnDemand,
      createdAt: createdAt,
      paidAt: paidAt ?? this.paidAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      completedAt: completedAt ?? this.completedAt,
      expiredAt: expiredAt ?? this.expiredAt,
    );
  }
}
