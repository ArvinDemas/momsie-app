class SlotItem {
  final String time;
  final int capacity;
  final int bookedCount;

  SlotItem({
    required this.time,
    required this.capacity,
    required this.bookedCount,
  });

  factory SlotItem.fromMap(Map<String, dynamic> map) {
    return SlotItem(
      time: map['time'] ?? '',
      capacity: (map['capacity'] as num?)?.toInt() ?? 1,
      bookedCount: (map['bookedCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'capacity': capacity,
      'bookedCount': bookedCount,
    };
  }

  bool get isFull => bookedCount >= capacity;

  SlotItem copyWith({String? time, int? capacity, int? bookedCount}) {
    return SlotItem(
      time: time ?? this.time,
      capacity: capacity ?? this.capacity,
      bookedCount: bookedCount ?? this.bookedCount,
    );
  }
}

class BookingSlotModel {
  final String docId;
  final String doulaId;
  final String tanggal; // format: "YYYY-MM-DD"
  final List<SlotItem> slots;
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
    List<SlotItem> slots = [];
    if (slotsRaw is List) {
      slots = slotsRaw.map((e) => SlotItem.fromMap(e as Map<String, dynamic>)).toList();
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
      'slots': slots.map((s) => s.toMap()).toList(),
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  BookingSlotModel copyWith({List<SlotItem>? slots}) {
    return BookingSlotModel(
      docId: docId,
      doulaId: doulaId,
      tanggal: tanggal,
      slots: slots ?? this.slots,
      createdAt: createdAt,
    );
  }
}
