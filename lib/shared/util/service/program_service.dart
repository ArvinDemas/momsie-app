import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:douce/shared/util/model/program_model.dart';

class ProgramService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ProgramModel>> getProgram() async {
    try {
      QuerySnapshot programSnapshot =
          await _firestore.collection('program').get();

      List<ProgramModel> programs = [];
      for (var doc in programSnapshot.docs) {
        var programData = doc.data() as Map<String, dynamic>;
        List<Month> months = [];

        QuerySnapshot monthSnapshot = await _firestore
            .collection('program')
            .doc(doc.id)
            .collection('bulan')
            .get();

        for (var monthDoc in monthSnapshot.docs) {
          var monthData = monthDoc.data() as Map<String, dynamic>;
          List<Week> weeks = [];

          QuerySnapshot weekSnapshot = await _firestore
              .collection('program')
              .doc(doc.id)
              .collection('bulan')
              .doc(monthDoc.id)
              .collection('minggu')
              .get();
          for (var weekDoc in weekSnapshot.docs) {
            var weekData = weekDoc.data() as Map<String, dynamic>;
            List<Move> moves = [];

            QuerySnapshot moveSnapshot = await _firestore
                .collection('program')
                .doc(doc.id)
                .collection('bulan')
                .doc(monthDoc.id)
                .collection('minggu')
                .doc(weekDoc.id)
                .collection('gerakan')
                .get();

            for (var moveDoc in moveSnapshot.docs) {
              var moveData = moveDoc.data() as Map<String, dynamic>;
              moves.add(Move(
                image: moveData['image'],
                name: moveData['judul'],
                petunjuk: moveData['petunjuk'],
                time: int.parse(moveData['waktu']),
              ));
            }
            weeks.add(Week(
              week: weekData['minggu'],
              image: weekData['image'],
              moves: moves,
            ));
          }
          months.add(Month(
            month: monthData['bulan'],
            weeks: weeks,
          ));
        }
        programs.add(ProgramModel(
          image: programData['image'],
          name: programData['nama'],
          desc: programData['desc'],
          months: months,
        ));
      }

      if (programs.isEmpty) {
        return _getMockPrograms();
      }
      return programs;
    } catch (e) {
      return _getMockPrograms();
    }
  }

  List<ProgramModel> _getMockPrograms() {
    return [
      ProgramModel(
        image: 'https://picsum.photos/seed/yoga1/300/300',
        name: 'Yoga Hamil & Meditasi',
        desc: 'Program latihan yoga prenatal untuk melatih pernapasan, kelenturan otot panggul, dan ketenangan pikiran menghadapi persalinan.',
        months: List.generate(9, (mIndex) {
          final monthNum = (mIndex + 1).toString();
          return Month(
            month: monthNum,
            weeks: List.generate(4, (wIndex) {
              final weekNum = (wIndex + 1).toString();
              return Week(
                week: weekNum,
                image: 'https://picsum.photos/seed/yogaweek${monthNum}_${weekNum}/400/250',
                moves: [
                  Move(
                    image: 'https://picsum.photos/seed/yogam1/300/300',
                    name: 'Pernapasan Diafragma (Deep Breathing)',
                    time: 60,
                    petunjuk: '1. Duduk dengan posisi tegak dan nyaman.\n2. Letakkan satu tangan di dada dan tangan lainnya di perut.\n3. Tarik napas perlahan melalui hidung hingga perut mengembang.\n4. Hembuskan napas perlahan melalui mulut.\n5. Lakukan berulang selama 1 menit.',
                  ),
                  Move(
                    image: 'https://picsum.photos/seed/yogam2/300/300',
                    name: 'Pose Kucing-Sapi (Cat-Cow Pose)',
                    time: 120,
                    petunjuk: '1. Mulai dengan posisi merangkak di matras.\n2. Sejajarkan pergelangan tangan dengan bahu, dan lutut dengan pinggul.\n3. Tarik napas, lengkungkan punggung ke bawah (pose sapi).\n4. Hembuskan napas, bulatkan punggung ke atas (pose kucing).\n5. Lakukan bergantian selama 2 menit.',
                  ),
                  Move(
                    image: 'https://picsum.photos/seed/yogam3/300/300',
                    name: 'Pose Kupu-Kupu (Butterfly Pose)',
                    time: 90,
                    petunjuk: '1. Duduk tegak dan pertemukan kedua telapak kaki di depan.\n2. Pegang pergelangan kaki, rapatkan tumit sedekat mungkin ke arah panggul.\n3. Ayunkan lutut ke atas dan bawah dengan lembut.\n4. Lakukan selama 1,5 menit.',
                  ),
                  Move(
                    image: 'https://picsum.photos/seed/yogam4/300/300',
                    name: 'Peregangan Pinggul Lambat (Gentle Bridge Pose)',
                    time: 60,
                    petunjuk: '1. Berbaring telentang dengan lutut ditekuk dan kaki rata di matras.\n2. Angkat pinggul Anda perlahan ke atas.\n3. Tahan beberapa detik lalu turunkan kembali secara perlahan.\n4. Lakukan berulang selama 1 menit.',
                  ),
                ],
              );
            }),
          );
        }),
      ),
    ];
  }
}
