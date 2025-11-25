import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'restaurant_app.db');

    return await openDatabase(
      path,
      version: 2, // Tăng version để migration
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tạo bảng restaurants
    await db.execute('''
      CREATE TABLE restaurants (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        address TEXT NOT NULL,
        category TEXT NOT NULL,
        description TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        rating REAL NOT NULL,
        reviewCount INTEGER NOT NULL,
        tags TEXT NOT NULL,
        createdAt INTEGER NOT NULL
      )
    ''');

    // Tạo bảng reviews
    await db.execute('''
      CREATE TABLE reviews (
        id TEXT PRIMARY KEY,
        restaurantId TEXT NOT NULL,
        userId TEXT NOT NULL,
        userName TEXT NOT NULL,
        rating REAL NOT NULL,
        comment TEXT NOT NULL,
        imageUrl TEXT,
        createdAt INTEGER NOT NULL,
        FOREIGN KEY (restaurantId) REFERENCES restaurants (id)
      )
    ''');

    // Insert sample data
    await _insertSampleData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Migration from version 1 to 2: Change rating column from INTEGER to REAL
      await db.execute('ALTER TABLE reviews ADD COLUMN rating_temp REAL');
      await db.execute('UPDATE reviews SET rating_temp = CAST(rating AS REAL)');
      await db.execute('ALTER TABLE reviews DROP COLUMN rating');
      await db.execute('ALTER TABLE reviews RENAME COLUMN rating_temp TO rating');
    }
  }

  Future<void> _insertSampleData(Database db) async {
    // Sample restaurants
    await db.insert('restaurants', {
      'id': '1',
      'name': 'Phở Hà Nội',
      'address': '123 Nguyễn Huệ, Q1, TP.HCM',
      'category': 'Vietnamese',
      'description': 'Phở bò truyền thống Hà Nội, nước dùng thơm ngon',
      'imageUrl': 'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=800',
      'rating': 4.5,
      'reviewCount': 12,
      'tags': '["Vietnamese", "Phở", "Traditional"]',
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });

    await db.insert('restaurants', {
      'id': '2',
      'name': 'Pizza Italia',
      'address': '456 Lê Lợi, Q1, TP.HCM',
      'category': 'Italian',
      'description': 'Pizza chính gốc Ý, lò nướng gỗ truyền thống',
      'imageUrl': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800',
      'rating': 4.8,
      'reviewCount': 25,
      'tags': '["Italian", "Pizza", "Pasta"]',
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });

    await db.insert('restaurants', {
      'id': '3',
      'name': 'Sushi Tokyo',
      'address': '789 Pasteur, Q3, TP.HCM',
      'category': 'Japanese',
      'description': 'Sushi tươi ngon, đầu bếp Nhật Bản chính hiệu',
      'imageUrl': 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=800',
      'rating': 4.7,
      'reviewCount': 18,
      'tags': '["Japanese", "Sushi", "Seafood"]',
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });
  }
}