class ProgramModel {
  final String image;
  final String name;
  final String desc;
  final List<Month> months;

  ProgramModel({
    required this.image,
    required this.name,
    required this.desc,
    required this.months,
  });

  factory ProgramModel.fromMap(Map<String, dynamic> map) {
    return ProgramModel(
      image: map['image'] ?? '',
      name: map['name'] ?? '',
      desc: map['desc'] ?? '',
      months: (map['months'] as List<dynamic>?)
              ?.map((m) => Month.fromMap(m as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'name': name,
      'desc': desc,
      'months': months.map((m) => m.toMap()).toList(),
    };
  }
}

class Month {
  final String month;
  final List<Week> weeks;

  Month({required this.month, required this.weeks});

  factory Month.fromMap(Map<String, dynamic> map) {
    return Month(
      month: map['month'] ?? '',
      weeks: (map['weeks'] as List<dynamic>?)
              ?.map((w) => Week.fromMap(w as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'month': month,
      'weeks': weeks.map((w) => w.toMap()).toList(),
    };
  }
}

class Week {
  final String week;
  final String image;
  final List<Move> moves;

  Week({required this.week, required this.image, required this.moves});

  factory Week.fromMap(Map<String, dynamic> map) {
    return Week(
      week: map['week'] ?? '',
      image: map['image'] ?? '',
      moves: (map['moves'] as List<dynamic>?)
              ?.map((mv) => Move.fromMap(mv as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'week': week,
      'image': image,
      'moves': moves.map((mv) => mv.toMap()).toList(),
    };
  }
}

class Move {
  final String image;
  final String name;
  final String petunjuk;
  final int time;

  Move({
    required this.image,
    required this.name,
    required this.time,
    required this.petunjuk,
  });

  factory Move.fromMap(Map<String, dynamic> map) {
    return Move(
      image: map['image'] ?? '',
      name: map['name'] ?? '',
      petunjuk: map['petunjuk'] ?? '',
      time: (map['time'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'name': name,
      'petunjuk': petunjuk,
      'time': time,
    };
  }
}
