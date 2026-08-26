class WithdrawalModel {
  final String id;
  final String doulaUid;
  final String doulaName;
  final int nominal;
  final String bank;
  final String noRekening;
  final String atasNama;
  final String status; // 'pending' | 'done' | 'rejected'
  final DateTime createdAt;

  WithdrawalModel({
    required this.id,
    required this.doulaUid,
    required this.doulaName,
    required this.nominal,
    required this.bank,
    required this.noRekening,
    required this.atasNama,
    required this.status,
    required this.createdAt,
  });

  factory WithdrawalModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return WithdrawalModel(
      id: id ?? map['id'] ?? '',
      doulaUid: map['doulaUid'] ?? '',
      doulaName: map['doulaName'] ?? '',
      nominal: (map['nominal'] as num?)?.toInt() ?? 0,
      bank: map['bank'] ?? '',
      noRekening: map['noRekening'] ?? '',
      atasNama: map['atasNama'] ?? '',
      status: map['status'] ?? 'pending',
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'doulaUid': doulaUid,
      'doulaName': doulaName,
      'nominal': nominal,
      'bank': bank,
      'noRekening': noRekening,
      'atasNama': atasNama,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}
