import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/city_model.dart';
import '../models/society_model.dart';

class LocalDatabaseService {
  static final LocalDatabaseService instance = LocalDatabaseService._init();
  static Database? _database;

  LocalDatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('sociohub.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Cities Table
    await db.execute('''
      CREATE TABLE cities(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL
      )
    ''');

    // Societies Table
    await db.execute('''
      CREATE TABLE societies(
        id TEXT PRIMARY KEY,
        city_id TEXT NOT NULL,
        name TEXT NOT NULL,
        area TEXT,
        FOREIGN KEY (city_id) REFERENCES cities (id) ON DELETE CASCADE
      )
    ''');
  }

  // City Operations
  Future<void> saveCities(List<City> cities) async {
    final db = await instance.database;
    final batch = db.batch();
    for (var city in cities) {
      batch.insert('cities', city.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<City>> getCities() async {
    final db = await instance.database;
    final result = await db.query('cities');
    return result.map((json) => City.fromJson(json)).toList();
  }

  // Society Operations
  Future<void> saveSocieties(List<Society> societies) async {
    final db = await instance.database;
    final batch = db.batch();
    for (var society in societies) {
      batch.insert('societies', society.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<Society>> getSocieties(String cityId) async {
    final db = await instance.database;
    final result = await db.query(
      'societies',
      where: 'city_id = ?',
      whereArgs: [cityId],
    );
    return result.map((json) => Society.fromJson(json)).toList();
  }

  Future<void> close() async {
    final db = await _database;
    if (db != null) {
      await db.close();
    }
  }
}
