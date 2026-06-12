import 'package:cloud_firestore/cloud_firestore.dart';

class DiaryModel {
  final String id;
  final String title;
  final String content;
  final String mood; // 'happy','love','calm','tired','anxious','sad'
  final int pregnancyWeek;
  final List<String> photoUrls; // Firebase Storage URLs
  final DateTime createdAt;

  const DiaryModel({
    required this.id,
    required this.title,
    required this.content,
    required this.mood,
    required this.pregnancyWeek,
    required this.photoUrls,
    required this.createdAt,
  });

  static const moodEmojis = {
    'happy': '😊',
    'love': '🥰',
    'calm': '😌',
    'tired': '😴',
    'anxious': '😰',
    'sad': '😢',
  };

  static const moodLabels = {
    'happy': 'Senang',
    'love': 'Penuh Cinta',
    'calm': 'Tenang',
    'tired': 'Lelah',
    'anxious': 'Cemas',
    'sad': 'Sedih',
  };

  String get moodEmoji => moodEmojis[mood] ?? '😊';
  String get moodLabel => moodLabels[mood] ?? mood;

  factory DiaryModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return DiaryModel(
      id: doc.id,
      title: d['title'] ?? '',
      content: d['content'] ?? '',
      mood: d['mood'] ?? 'happy',
      pregnancyWeek: (d['pregnancyWeek'] ?? 0) as int,
      photoUrls: List<String>.from(d['photoUrls'] ?? []),
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'title': title,
        'content': content,
        'mood': mood,
        'pregnancyWeek': pregnancyWeek,
        'photoUrls': photoUrls,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  DiaryModel copyWith({
    String? id,
    String? title,
    String? content,
    String? mood,
    int? pregnancyWeek,
    List<String>? photoUrls,
    DateTime? createdAt,
  }) {
    return DiaryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      pregnancyWeek: pregnancyWeek ?? this.pregnancyWeek,
      photoUrls: photoUrls ?? this.photoUrls,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
