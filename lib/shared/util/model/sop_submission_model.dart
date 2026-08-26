import 'package:cloud_firestore/cloud_firestore.dart';

class SopSubmissionModel {
  final String id;
  final String userId;
  final String userEmail;
  final String userName;
  final String nik;
  final String nohp;
  final String kotaProvinsi;
  final String role;
  final String status; // pending, approved, rejected
  final String? rejectionReason;
  final DateTime? submittedAt;
  final String? ktpUrl;
  final String? sertifikatUrl;
  final String? csMessage;

  SopSubmissionModel({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.nik,
    required this.nohp,
    required this.kotaProvinsi,
    required this.role,
    required this.status,
    this.rejectionReason,
    this.submittedAt,
    this.ktpUrl,
    this.sertifikatUrl,
    this.csMessage,
  });

  factory SopSubmissionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SopSubmissionModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      userEmail: data['userEmail'] ?? '',
      userName: data['userName'] ?? '',
      nik: data['nik'] ?? '',
      nohp: data['nohp'] ?? '',
      kotaProvinsi: data['kotaProvinsi'] ?? '',
      role: data['role'] ?? '',
      status: data['status'] ?? 'pending',
      rejectionReason: data['rejectionReason'],
      submittedAt: (data['submittedAt'] as Timestamp?)?.toDate(),
      ktpUrl: data['ktpUrl'],
      sertifikatUrl: data['sertifikatUrl'],
      csMessage: data['csMessage'],
    );
  }
}
