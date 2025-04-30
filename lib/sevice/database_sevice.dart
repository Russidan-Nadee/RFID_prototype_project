import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static Database? _db;

  // ฟังก์ชันเปิดฐานข้อมูลหากยังไม่ได้เปิด
  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  // ฟังก์ชันเปิดหรือสร้างฐานข้อมูล
  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "assetsdb.db");

    bool exists = await File(path).exists();
    print('Database exists at path: $exists');

    if (!exists) {
      ByteData data = await rootBundle.load('assets/assetsdb.db');
      List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );

      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(path); // เปิดฐานข้อมูล
  }

  // ฟังก์ชันดึงข้อมูลทั้งหมดจากตาราง assets
  Future<List<Map<String, dynamic>>> getAssets() async {
    var dbClient = await db;
    return await dbClient.query('assets');
  }

  // ฟังก์ชันดึงข้อมูลจากฐานข้อมูลโดยใช้ UID
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
    return null; // ถ้าไม่พบข้อมูล
  }

  // ฟังก์ชันบันทึกข้อมูลใหม่ลงในตาราง 'assets'
  Future<void> insertNewAsset(String id, String category, String brand, String department, String uid, String date) async {
    var dbClient = await db;

    // แปลง ID และ UID เป็นตัวพิมพ์ใหญ่
    id = id.toUpperCase();
    uid = uid.toUpperCase();

    Map<String, dynamic> asset = {
      'id': id,
      'uid': uid,
      'category': category,
      'brand': brand,
      'department': department,
      'date': date,
      'status': 'Available', // กำหนดค่า status เป็น 'Available'
    };

    try {
      await dbClient.insert(
        'assets',
        asset,
        conflictAlgorithm: ConflictAlgorithm.replace, // หากมีข้อมูลซ้ำจะทำการแทนที่
      );
      print('Data inserted successfully');
    } catch (e) {
      print('Error inserting data: $e');
    }
  }

  // ฟังก์ชันลบข้อมูลทั้งหมดจากตาราง 'assets'
  Future<void> deleteAllAssets() async {
    var dbClient = await db;
    try {
      await dbClient.delete('assets');  // ลบข้อมูลทั้งหมดจากตาราง assets
      print('All data deleted successfully');
    } catch (e) {
      print('Error deleting all data: $e');
    }
  }

  // ฟังก์ชันลบข้อมูลจากตาราง 'assets' โดยใช้ UID
  Future<void> deleteAssetByUid(String uid) async {
    var dbClient = await db;

    try {
      await dbClient.delete(
        'assets', // ชื่อตาราง
        where: 'uid = ?', // เงื่อนไขในการลบ
        whereArgs: [uid], // ตัวแปรที่ใช้ในการค้นหา (UID)
      );
      print('Data with UID $uid deleted successfully');
    } catch (e) {
      print('Error deleting data with UID $uid: $e');
    }
  }

  // ฟังก์ชันอัปเดตสถานะในตาราง 'assets' จาก "Available" เป็น "Checked In"
  Future<bool> updateStatus(String uid, String status) async {
    var dbClient = await db;

    // ตรวจสอบว่า status ที่ส่งมาคือ "Checked In" หรือไม่
    Map<String, dynamic> updatedStatus = {
      'status': status, // อัพเดต status เป็นค่าที่รับเข้ามา
    };

    try {
      // อัปเดตข้อมูลในตาราง 'assets' โดยใช้ UID เป็นเงื่อนไข
      int count = await dbClient.update(
        'assets', // ชื่อตาราง
        updatedStatus, // ข้อมูลที่ต้องการอัปเดต
        where: 'uid = ?', // ค้นหาตาม UID
        whereArgs: [uid], // ตัวแปรที่ใช้ในการค้นหา (UID)
      );

      if (count > 0) {
        print('Status updated to $status successfully');
        return true; // ถ้าประสบความสำเร็จ
      } else {
        print('No asset found with UID $uid');
        return false; // ถ้าไม่พบข้อมูลที่ต้องการอัปเดต
      }
    } catch (e) {
      print('Error updating status: $e');
      return false; // ถ้าเกิดข้อผิดพลาด
    }
  }
}
