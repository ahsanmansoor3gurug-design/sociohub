import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/city_model.dart';
import '../models/society_model.dart';
import '../models/emergency_contact_model.dart';

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
      version: 2, // Incremented version to add new table
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cities(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE societies(
        id TEXT PRIMARY KEY,
        city_id TEXT NOT NULL,
        name TEXT NOT NULL,
        area TEXT,
        FOREIGN KEY (city_id) REFERENCES cities (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE emergency_contacts(
        id TEXT PRIMARY KEY,
        society_id TEXT NOT NULL,
        name TEXT NOT NULL,
        phone_number TEXT NOT NULL,
        category TEXT NOT NULL
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE emergency_contacts(
          id TEXT PRIMARY KEY,
          society_id TEXT NOT NULL,
          name TEXT NOT NULL,
          phone_number TEXT NOT NULL,
          category TEXT NOT NULL
        )
      ''');
    }
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

  // Emergency Contact Operations
  Future<void> saveEmergencyContacts(List<EmergencyContact> contacts) async {
    final db = await instance.database;
    final batch = db.batch();
    for (var contact in contacts) {
      batch.insert('emergency_contacts', contact.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<EmergencyContact>> getEmergencyContacts(String societyId) async {
    final db = await instance.database;
    final result = await db.query(
      'emergency_contacts',
      where: 'society_id = ?',
      whereArgs: [societyId],
    );
    return result.map((json) => EmergencyContact.fromJson(json)).toList();
  }

  Future<void> close() async {
    final db = await _database;
    if (db != null) {
      await db.close();
    }
  }
}
