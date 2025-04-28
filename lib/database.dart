import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/services.dart';

class DatabaseHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "assetsdb.db");

    // เช็คว่ามีไฟล์ฐานข้อมูลอยู่หรือไม่
    bool exists = await File(path).exists();
    print('Database exists at path: $exists');

    // ถ้าไม่มีไฟล์ฐานข้อมูลอยู่ ให้โหลดมาจาก asset
    if (!exists) {
      ByteData data = await rootBundle.load('assets/assetsdb.db');
      List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );

      // บันทึกไฟล์ฐานข้อมูลใหม่ที่ Document Directory
      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(path);
  }

  Future<List<Map<String, dynamic>>> getAssets() async {
    var dbClient = await db;
    return await dbClient.query('assets');
  }

  Future<Map<String, dynamic>?> getAssetByUid(String uid) async {
    var dbClient = await db;
    List<Map> results = await dbClient.query(
      'assets',
      where: 'uid = ?',
      whereArgs: [uid],
    );
    if (results.isNotEmpty) {
      return results.first as Map<String, dynamic>;
    }
    return null;
  }
}
