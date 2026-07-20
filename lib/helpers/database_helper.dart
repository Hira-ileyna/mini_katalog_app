import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:mini_katalog_app/models/product.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('products.db');
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

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        description TEXT NOT NULL,
        imageUrl TEXT NOT NULL
      )
    ''');

    for (var product in dummyProducts) {
      await db.insert('products', product.toMap());
    }
  }

  // 1. Tüm Ürünleri Getir
  Future<List<Product>> getProducts() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('products');
    return result.map((json) => Product.fromMap(json)).toList();
  }

  // 2. Ürün Ekle
  Future<int> insertProduct(Product product) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('products', product.toMap());
  }

  // 3. Ürün Güncelle
  Future<int> updateProduct(Product product) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  // 4. Ürün Sil
  Future<int> deleteProduct(String id) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}