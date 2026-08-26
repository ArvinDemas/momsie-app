class BookingSlotModel {
  final String docId;
  final String doulaId;
  final String tanggal; // format: "YYYY-MM-DD"
  final List<String> slots; // contoh: ["09:00", "10:00", "13:00"]
  final DateTime createdAt;

  BookingSlotModel({
    required this.docId,
    required this.doulaId,
    required this.tanggal,
    required this.slots,
    required this.createdAt,
  });

  factory BookingSlotModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    final slotsRaw = map['slots'];
    List<String> slots = [];
    if (slotsRaw is List) {
      slots = slotsRaw.map((e) => e.toString()).toList();
    } else if (slotsRaw is String) {
      slots = [slotsRaw];
    }
    return BookingSlotModel(
      docId: docId ?? map['docId'] ?? '',
      doulaId: map['doulaId'] ?? '',
      tanggal: map['tanggal'] ?? '',
      slots: slots,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'doulaId': doulaId,
      'tanggal': tanggal,
      'slots': slots,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  BookingSlotModel copyWith({List<String>? slots}) {
    return BookingSlotModel(
      docId: docId,
      doulaId: doulaId,
      tanggal: tanggal,
      slots: slots ?? this.slots,
      createdAt: createdAt,
    );
  }
}
