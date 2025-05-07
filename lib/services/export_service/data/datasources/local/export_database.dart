import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ExportDatabase {
  static final ExportDatabase _instance = ExportDatabase._internal();
  factory ExportDatabase() => _instance;
  ExportDatabase._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await init();
    return _database!;
  }

  Future<Database> init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'exports.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // สร้างตารางประวัติการส่งออก
        await db.execute('''
        CREATE TABLE exports(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          filename TEXT,
          format TEXT,
          recordCount INTEGER,
          exportDate TEXT,
          generatedBy TEXT,
          filePath TEXT
        )
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> getExportHistory() async {
    final db = await database;
    return await db.query('exports', orderBy: 'exportDate DESC');
  }

  Future<int> insertExportRecord(Map<String, dynamic> record) async {
    final db = await database;
    return await db.insert('exports', record);
  }

  Future<Map<String, dynamic>?> getExportById(int id) async {
    final db = await database;
    final results = await db.query('exports', where: 'id = ?', whereArgs: [id]);
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> deleteExport(int id) async {
    final db = await database;
    await db.delete('exports', where: 'id = ?', whereArgs: [id]);
  }
}
