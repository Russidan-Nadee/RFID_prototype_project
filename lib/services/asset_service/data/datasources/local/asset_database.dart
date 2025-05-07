import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../../../../core/constants/app_constants.dart';

class AssetDatabase {
  static final AssetDatabase _instance = AssetDatabase._internal();
  factory AssetDatabase() => _instance;
  AssetDatabase._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await init();
    return _database!;
  }

  Future<Database> init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'assets.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // สร้างตารางสินทรัพย์
        await db.execute('''
        CREATE TABLE assets(
          id TEXT PRIMARY KEY,
          uid TEXT UNIQUE,
          category TEXT,
          brand TEXT,
          department TEXT,
          status TEXT,
          date TEXT
        )
        ''');

        // สร้างตารางหมวดหมู่
        await db.execute('''
        CREATE TABLE categories(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT UNIQUE
        )
        ''');

        // สร้างตารางแผนก
        await db.execute('''
        CREATE TABLE departments(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT UNIQUE
        )
        ''');

        // เพิ่มข้อมูลเริ่มต้น
        for (String category in AppConstants.defaultAssetCategories) {
          await db.insert('categories', {'name': category});
        }

        for (String department in AppConstants.defaultDepartments) {
          await db.insert('departments', {'name': department});
        }
      },
    );
  }

  // เมธอดสำหรับจัดการข้อมูลสินทรัพย์
  Future<List<Map<String, dynamic>>> getAssets() async {
    final db = await database;
    return await db.query('assets');
  }

  Future<Map<String, dynamic>?> getAssetByUid(String uid) async {
    final db = await database;
    final results = await db.query(
      'assets',
      where: 'uid = ?',
      whereArgs: [uid],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> insertAsset(Map<String, dynamic> asset) async {
    final db = await database;
    await db.insert(
      'assets',
      asset,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> updateAssetStatus(String uid, String status) async {
    final db = await database;
    final count = await db.update(
      'assets',
      {'status': status},
      where: 'uid = ?',
      whereArgs: [uid],
    );
    return count > 0;
  }

  Future<bool> updateAsset(Map<String, dynamic> asset) async {
    final db = await database;
    final count = await db.update(
      'assets',
      asset,
      where: 'uid = ?',
      whereArgs: [asset['uid']],
    );
    return count > 0;
  }

  Future<void> deleteAsset(String uid) async {
    final db = await database;
    await db.delete('assets', where: 'uid = ?', whereArgs: [uid]);
  }

  Future<void> deleteAllAssets() async {
    final db = await database;
    await db.delete('assets');
  }

  // เมธอดสำหรับจัดการหมวดหมู่
  Future<List<String>> getCategories() async {
    final db = await database;
    final results = await db.query('categories');
    return results.map((map) => map['name'] as String).toList();
  }

  Future<void> addCategory(String name) async {
    final db = await database;
    await db.insert('categories', {'name': name});
  }

  Future<void> updateCategory(String oldName, String newName) async {
    final db = await database;
    await db.update(
      'categories',
      {'name': newName},
      where: 'name = ?',
      whereArgs: [oldName],
    );

    // อัปเดตสินทรัพย์ที่ใช้หมวดหมู่นี้
    await db.update(
      'assets',
      {'category': newName},
      where: 'category = ?',
      whereArgs: [oldName],
    );
  }

  Future<void> deleteCategory(String name) async {
    final db = await database;
    await db.delete('categories', where: 'name = ?', whereArgs: [name]);
  }

  // เมธอดสำหรับจัดการแผนก
  Future<List<String>> getDepartments() async {
    final db = await database;
    final results = await db.query('departments');
    return results.map((map) => map['name'] as String).toList();
  }

  Future<void> addDepartment(String name) async {
    final db = await database;
    await db.insert('departments', {'name': name});
  }

  Future<void> updateDepartment(String oldName, String newName) async {
    final db = await database;
    await db.update(
      'departments',
      {'name': newName},
      where: 'name = ?',
      whereArgs: [oldName],
    );

    // อัปเดตสินทรัพย์ที่ใช้แผนกนี้
    await db.update(
      'assets',
      {'department': newName},
      where: 'department = ?',
      whereArgs: [oldName],
    );
  }

  Future<void> deleteDepartment(String name) async {
    final db = await database;
    await db.delete('departments', where: 'name = ?', whereArgs: [name]);
  }

  Future<String?> getRandomUid() async {
    final db = await database;
    final results = await db.rawQuery(
      'SELECT uid FROM assets ORDER BY RANDOM() LIMIT 1',
    );
    return results.isNotEmpty ? results.first['uid'] as String? : null;
  }
}
