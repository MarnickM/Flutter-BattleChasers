import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Future<Database> _openDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'battle_chasers.db'),
      onCreate: (db, version) {
        db.execute('CREATE TABLE scores(id INTEGER PRIMARY KEY, username TEXT, score INTEGER)');
        db.execute('CREATE TABLE achievements(id TEXT PRIMARY KEY)');
      },
      version: 1,
    );
  }

  static Future<void> insertScore(String username, int score) async {
    final db = await _openDatabase();
    await db.insert('scores', {'username': username, 'score': score});
  }

  static Future<void> insertAchievement(String dragonID) async {
    final db = await _openDatabase();
    await db.insert(
      'achievements',
      {'id': dragonID},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  static Future<List<Map<String, dynamic>>> fetchScores() async {
    final db = await _openDatabase();
    return db.query('scores', orderBy: 'score DESC');
  }

  static Future<List<String>> fetchAchievements() async {
    final db = await _openDatabase();
    final List<Map<String, dynamic>> results = await db.query('achievements');
    return results.map((row) => row['id'] as String).toList();
  }
}
