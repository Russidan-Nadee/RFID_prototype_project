import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

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

    bool exists = await File(path).exists();
    if (!exists) {
      ByteData data = await rootBundle.load('assets/assetsdb.db');
      List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(path);
  }

  Future<List<Map<String, dynamic>>> getAssets() async {
    try {
      var dbClient = await db;
      return await dbClient.query('assets');
    } catch (e) {
      throw Exception('Error fetching assets: $e');
    }
  }

  Future<Map<String, dynamic>?> getAssetByUid(String uid) async {
    try {
      var dbClient = await db;
      List<Map<String, dynamic>> results = await dbClient.query(
        'assets',
        where: 'uid = ?',
        whereArgs: [uid],
      );
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      throw Exception('Error fetching asset by UID $uid: $e');
    }
  }

  Future<void> insertNewAsset(
    String id,
    String category,
    String brand,
    String department,
    String uid,
    String date,
  ) async {
    try {
      var dbClient = await db;
      id = id.toUpperCase();
      uid = uid.toUpperCase();

      Map<String, dynamic> asset = {
        'id': id,
        'uid': uid,
        'category': category,
        'brand': brand,
        'department': department,
        'date': date,
        'status': 'Available',
      };

      await dbClient.insert(
        'assets',
        asset,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Error inserting data: $e');
    }
  }

  Future<void> deleteAllAssets() async {
    try {
      var dbClient = await db;
      await dbClient.delete('assets');
    } catch (e) {
      throw Exception('Error deleting all data: $e');
    }
  }

  Future<void> deleteAssetByUid(String uid) async {
    try {
      var dbClient = await db;
      await dbClient.delete('assets', where: 'uid = ?', whereArgs: [uid]);
    } catch (e) {
      throw Exception('Error deleting data with UID $uid: $e');
    }
  }

  Future<bool> updateStatus(String uid, String status) async {
    try {
      var dbClient = await db;
      Map<String, dynamic> updatedStatus = {'status': status};

      int count = await dbClient.update(
        'assets',
        updatedStatus,
        where: 'uid = ?',
        whereArgs: [uid],
      );

      return count > 0;
    } catch (e) {
      throw Exception('Error updating status: $e');
    }
  }
}
