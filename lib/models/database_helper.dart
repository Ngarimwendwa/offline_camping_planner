// ignore: unused_import
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'camping_site.dart';

class DatabaseHelper {
  static final _databaseName = "offlineCampingPlanner.db";
  static final _databaseVersion = 1;

  // Singleton instance
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Database connection
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  // Create table on database creation
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${CampingSite.table} (
        ${CampingSite.columnId} INTEGER PRIMARY KEY,
        ${CampingSite.columnName} TEXT NOT NULL,
        ${CampingSite.columnLocation} TEXT NOT NULL,
        ${CampingSite.columnDescription} TEXT NOT NULL
      )
    ''');
  }

  // CRUD operations

  // Get all camping sites
  Future<List<CampingSite>> getAllCampingSites() async {
    final db = await instance.database;
    final result = await db.query(CampingSite.table);

    return result.map((json) => CampingSite.fromMap(json)).toList();
  }

  // Insert a camping site
  Future<int> insertCampingSite(CampingSite campingSite) async {
    final db = await instance.database;
    return db.insert(CampingSite.table, campingSite.toMap());
  }

  // Update a camping site
  Future<int> updateCampingSite(CampingSite campingSite) async {
    final db = await instance.database;
    return db.update(CampingSite.table, campingSite.toMap(), where: '${CampingSite.columnId} = ?', whereArgs: [campingSite.id]);
  }

  // Delete a camping site
  Future<int> deleteCampingSite(int id) async {
    final db = await instance.database;
    return db.delete(CampingSite.table, where: '${CampingSite.columnId} = ?', whereArgs: [id]);
  }
}