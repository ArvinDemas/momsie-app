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

      return programs;
    } catch (e) {
      return [];
    }
  }
}
