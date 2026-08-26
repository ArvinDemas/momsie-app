import 'package:cloud_firestore/cloud_firestore.dart';

class DiaryModel {
  final String id;
  final String title;
  final String content;
  final String mood; // 'happy','love','calm','tired','anxious','excited'
  final int pregnancyWeek; // Store week number (1-42) or month/year number
  final bool isBabyBorn;
  final String babyAgeUnit; // 'bulan' or 'tahun'
  final List<String> photoUrls;
  final DateTime createdAt;

  const DiaryModel({
    required this.id,
    required this.title,
    required this.content,
    required this.mood,
    required this.pregnancyWeek,
    this.isBabyBorn = false,
    this.babyAgeUnit = 'bulan',
    required this.photoUrls,
    required this.createdAt,
  });

  static const moodEmojis = {
    'happy': '😊',
    'love': '🥰',
    'calm': '😌',
    'tired': '😴',
    'anxious': '🥺',
    'excited': '🤩',
  };

  static const moodLabels = {
    'happy': 'Bahagia',
    'love': 'Haru & Cinta',
    'calm': 'Tenang',
    'tired': 'Lelah',
    'anxious': 'Cemas',
    'excited': 'Semangat',
  };

  String get moodEmoji => moodEmojis[mood] ?? '😊';
  String get moodLabel => moodLabels[mood] ?? 'Bahagia';

  String get ageLabel {
    if (isBabyBorn) {
      final unit = babyAgeUnit == 'tahun' ? 'Tahun' : 'Bulan';
      return 'Bayi $pregnancyWeek $unit';
    }
    return 'Minggu $pregnancyWeek';
  }

  factory DiaryModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return DiaryModel(
      id: doc.id,
      title: d['title'] ?? '',
      content: d['content'] ?? '',
      mood: d['mood'] ?? 'happy',
      pregnancyWeek: (d['pregnancyWeek'] ?? 20) as int,
      isBabyBorn: (d['isBabyBorn'] ?? false) as bool,
      babyAgeUnit: d['babyAgeUnit'] ?? 'bulan',
      photoUrls: List<String>.from(d['photoUrls'] ?? []),
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'title': title,
        'content': content,
        'mood': mood,
        'pregnancyWeek': pregnancyWeek,
        'isBabyBorn': isBabyBorn,
        'babyAgeUnit': babyAgeUnit,
        'photoUrls': photoUrls,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  DiaryModel copyWith({
    String? id,
    String? title,
    String? content,
    String? mood,
    int? pregnancyWeek,
    bool? isBabyBorn,
    String? babyAgeUnit,
    List<String>? photoUrls,
    DateTime? createdAt,
  }) {
    return DiaryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      pregnancyWeek: pregnancyWeek ?? this.pregnancyWeek,
      isBabyBorn: isBabyBorn ?? this.isBabyBorn,
      babyAgeUnit: babyAgeUnit ?? this.babyAgeUnit,
      photoUrls: photoUrls ?? this.photoUrls,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
