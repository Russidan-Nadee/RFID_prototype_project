import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _db;

  // ฟังก์ชันเชื่อมต่อกับฐานข้อมูล
  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  // ฟังก์ชันในการสร้างฐานข้อมูล
  Future<Database> initDB() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, "assetsdb.db");

      // เปิดฐานข้อมูล
      return await openDatabase(path, version: 1, onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE assets(id TEXT PRIMARY KEY, category TEXT, brand TEXT, department TEXT, status TEXT, date TEXT)',
        );
      });
    } catch (e) {
      print("Error initializing database: $e");
      rethrow;
    }
  }

  // ฟังก์ชันดึงข้อมูลจาก asset โดยใช้ uid
  Future<Map<String, dynamic>?> getAssetByUid(String uid) async {
    var dbClient = await db;
    List<Map> results = await dbClient.query(
      'assets',
      where: 'id = ?',
      whereArgs: [uid],
    );
    if (results.isNotEmpty) {
      return results.first as Map<String, dynamic>;
    }
    return null;
  }

  // ฟังก์ชันดึงข้อมูลทั้งหมดจากตาราง assets
  Future<List<Map<String, dynamic>>> getAssets() async {
    var dbClient = await db;
    return await dbClient.query('assets');
  }

  // ฟังก์ชันอัปเดตสถานะของ asset
  Future<void> updateAssetStatus(String uid, String status, String date) async {
    var dbClient = await db;
    await dbClient.update(
      'assets',
      {'status': status, 'date': date},
      where: 'id = ?',
      whereArgs: [uid],
    );
  }

  // ฟังก์ชันเพิ่ม asset ใหม่
  Future<void> insertNewAsset(Map<String, dynamic> asset) async {
    var dbClient = await db;
    await dbClient.insert(
      'assets',
      asset,
      conflictAlgorithm: ConflictAlgorithm.replace, // ถ้ามีข้อมูลที่ซ้ำกันจะทำการแทนที่
    );
  }
}
