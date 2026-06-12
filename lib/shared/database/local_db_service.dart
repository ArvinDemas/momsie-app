import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class LocalDbService {
  static Database? _db;
  static const String _dbName = 'statictext.db';

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, _dbName);

    // Copy from assets on first run (or if not present)
    if (!await File(path).exists()) {
      final data = await rootBundle.load('assets/statictext.db');
      final bytes = data.buffer.asUint8List();
      await File(path).writeAsBytes(bytes, flush: true);
    }

    return openDatabase(path, readOnly: true);
  }

  /// Ambil data sizeguide berdasarkan minggu kehamilan (week 3–42).
  /// Jika [week] tidak ditemukan, fallback ke minggu 20.
  static Future<Map<String, dynamic>?> getSizeGuide(int week) async {
    final db = await database;
    final clamped = week.clamp(3, 42);
    final results = await db.query(
      'sizeguide',
      where: 'week = ?',
      whereArgs: [clamped.toString()],
      limit: 1,
    );
    if (results.isNotEmpty) return results.first;

    // fallback: minggu 20
    final fallback = await db.query(
      'sizeguide',
      where: 'week = ?',
      whereArgs: ['20'],
      limit: 1,
    );
    return fallback.isNotEmpty ? fallback.first : null;
  }

  /// Ambil tips harian berdasarkan minggu kehamilan.
  static Future<Map<String, dynamic>?> getTodayTips(int week) async {
    final db = await database;
    final clamped = week.clamp(4, 42);
    final results = await db.query(
      'today_tips',
      where: 'week = ?',
      whereArgs: [clamped],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }
}
