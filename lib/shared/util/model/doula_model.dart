class DoulaModel {
  final String uid;
  final String image;
  final String name;
  final String job;
  final String alamat;
  final String jenisKelamin;
  final String biografi;
  final String rating;

  DoulaModel({
    required this.uid,
    required this.image,
    required this.name,
    required this.job,
    required this.alamat,
    required this.jenisKelamin,
    required this.biografi,
    required this.rating,
  });

  factory DoulaModel.fromMap(Map<String, dynamic> map, {String uid = ''}) {
    return DoulaModel(
      uid: uid,
      image: map['image'] ?? '',
      name: map['name'] ?? '',
      job: map['pekerjaan'] ?? '',
      alamat: map['alamat'] ?? '',
      jenisKelamin: map['jenisKelamin'] ?? '',
      biografi: map['biografi'] ?? '',
      rating: map['rating']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'name': name,
      'pekerjaan': job,
      'alamat': alamat,
      'jenisKelamin': jenisKelamin,
      'biografi': biografi,
      'rating': rating,
    };
  }
}
