class ProgramModel {
  String image;
  String name;
  String desc;
  List<Month> months;

  ProgramModel({
    required this.image,
    required this.name,
    required this.desc,
    required this.months,
  });
}

class Month {
  String month;
  List<Week> weeks;

  Month({required this.month, required this.weeks});
}

class Week {
  String week;
  String image;
  List<Move> moves;

  Week({required this.week, required this.image, required this.moves});
}

class Move {
  String image;
  String name;
  String petunjuk;
  int time;

  Move({
    required this.image,
    required this.name,
    required this.time,
    required this.petunjuk,
  });
}
