class SlotItem {
  final String time;
  final int capacity;
  final int bookedCount;

  SlotItem({
    required this.time,
    required this.capacity,
    required this.bookedCount,
  });

  factory SlotItem.fromMap(Map<dynamic, dynamic> map) {
    return SlotItem(
      time: map['time']?.toString() ?? '',
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
      for (var e in slotsRaw) {
        if (e is Map) {
          slots.add(SlotItem.fromMap(e));
        } else if (e is String) {
          slots.add(SlotItem(time: e, capacity: 1, bookedCount: 0));
        }
      }
    }

    DateTime createdAt = DateTime.now();
    final rawCreated = map['createdAt'];
    if (rawCreated is int) {
      createdAt = DateTime.fromMillisecondsSinceEpoch(rawCreated);
    } else if (rawCreated != null) {
      try {
        createdAt = (rawCreated as dynamic).toDate();
      } catch (_) {
        createdAt = DateTime.now();
      }
    }

    return BookingSlotModel(
      docId: docId ?? map['docId']?.toString() ?? '',
      doulaId: map['doulaId']?.toString() ?? '',
      tanggal: map['tanggal']?.toString() ?? '',
      slots: slots,
      createdAt: createdAt,
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
