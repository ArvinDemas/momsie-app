class HarianModel {
  final String yourBaby;
  final String yourBody;
  final String nutritionTips;

  HarianModel({
    required this.yourBaby,
    required this.yourBody,
    required this.nutritionTips,
  });

  factory HarianModel.fromMap(Map<String, dynamic> map) {
    return HarianModel(
      yourBaby: map['your_baby'] ?? '',
      yourBody: map['your_body'] ?? '',
      nutritionTips: map['nutrition_tips'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'your_baby': yourBaby,
      'your_body': yourBody,
      'nutrition_tips': nutritionTips,
    };
  }
}
