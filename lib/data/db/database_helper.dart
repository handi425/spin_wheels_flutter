import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spin_wheels/config/app_config.dart';

/// Implementasi Database Helper untuk mengelola koneksi database SQLite
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Singleton pattern
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  /// Getter untuk mengakses database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Inisialisasi database
  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, AppConfig.databaseName);

    return await openDatabase(
      path,
      version: AppConfig.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Membuat tabel saat database pertama kali dibuat
  Future<void> _onCreate(Database db, int version) async {
    // Tabel users
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.usersTable}(
        ${DatabaseConstants.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DatabaseConstants.colUserName} TEXT NOT NULL,
        ${DatabaseConstants.colUserEmail} TEXT,
        ${DatabaseConstants.colUserPhone} TEXT,
        ${DatabaseConstants.colUserAddress} TEXT,
        ${DatabaseConstants.colUserInvoice} TEXT,
        ${DatabaseConstants.colCreatedAt} TEXT NOT NULL,
        ${DatabaseConstants.colUpdatedAt} TEXT NOT NULL
      )
    ''');

    // Tabel prizes
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.prizesTable}(
        ${DatabaseConstants.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DatabaseConstants.colPrizeName} TEXT NOT NULL,
        ${DatabaseConstants.colPrizeDescription} TEXT,
        ${DatabaseConstants.colPrizeValue} REAL,
        ${DatabaseConstants.colPrizeColor} TEXT NOT NULL,
        ${DatabaseConstants.colPrizeProbability} REAL,
        ${DatabaseConstants.colPrizeAvailableCount} INTEGER NOT NULL,
        ${DatabaseConstants.colPrizeImagePath} TEXT,
        ${DatabaseConstants.colCreatedAt} TEXT NOT NULL,
        ${DatabaseConstants.colUpdatedAt} TEXT NOT NULL
      )
    ''');

    // Tabel spin_history
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.spinHistoryTable}(
        ${DatabaseConstants.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DatabaseConstants.colSpinHistoryUserId} INTEGER NOT NULL,
        ${DatabaseConstants.colSpinHistoryPrizeId} INTEGER NOT NULL,
        ${DatabaseConstants.colSpinHistoryIsSent} INTEGER NOT NULL DEFAULT 0,
        ${DatabaseConstants.colSpinHistorySentAt} TEXT,
        ${DatabaseConstants.colSpinHistoryNotes} TEXT,
        ${DatabaseConstants.colCreatedAt} TEXT NOT NULL,
        FOREIGN KEY (${DatabaseConstants.colSpinHistoryUserId}) 
          REFERENCES ${DatabaseConstants.usersTable} (${DatabaseConstants.colId}) 
          ON DELETE CASCADE,
        FOREIGN KEY (${DatabaseConstants.colSpinHistoryPrizeId}) 
          REFERENCES ${DatabaseConstants.prizesTable} (${DatabaseConstants.colId}) 
          ON DELETE CASCADE
      )
    ''');
  }

  /// Update database ketika versi berubah
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Implementasi upgrade database
    if (oldVersion < 2) {
      // Tambahkan kolom address dan invoice ke tabel users jika upgrade ke versi 2
      try {
        await db.execute('''
          ALTER TABLE ${DatabaseConstants.usersTable}
          ADD COLUMN ${DatabaseConstants.colUserAddress} TEXT;
        ''');

        await db.execute('''
          ALTER TABLE ${DatabaseConstants.usersTable}
          ADD COLUMN ${DatabaseConstants.colUserInvoice} TEXT;
        ''');
      } catch (e) {
        print('Error saat upgrade database: $e');
      }
    }
  }

  /// Menutup koneksi database
  Future<void> close() async {
    final db = await database;
    db.close();
  }

  /// Insert record baru ke database
  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    return await db.insert(table, values);
  }

  /// Update record di database
  Future<int> update(
    String table,
    Map<String, dynamic> values,
    String whereClause,
    List<dynamic> whereArgs,
  ) async {
    final db = await database;
    return await db.update(
      table,
      values,
      where: whereClause,
      whereArgs: whereArgs,
    );
  }

  /// Delete record dari database
  Future<int> delete(
    String table,
    String whereClause,
    List<dynamic> whereArgs,
  ) async {
    final db = await database;
    return await db.delete(table, where: whereClause, whereArgs: whereArgs);
  }

  /// Query record dari database
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    return await db.query(
      table,
      columns: columns?.split(','),
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  /// Raw query untuk query kompleks
  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<dynamic>? arguments,
  ]) async {
    final db = await database;
    return await db.rawQuery(sql, arguments);
  }
}
