import 'package:spin_wheels/config/app_config.dart';
import 'package:spin_wheels/data/db/database_helper.dart';
import 'package:spin_wheels/data/models/user_model.dart';

/// Repository untuk mengakses dan mengelola data User
class UserRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  /// Mendapatkan semua user
  Future<List<User>> getUsers() async {
    final maps = await _databaseHelper.query(
      DatabaseConstants.usersTable,
      orderBy: '${DatabaseConstants.colUserName} ASC',
    );
    
    return maps.map((map) => User.fromMap(map)).toList();
  }

  /// Mendapatkan user berdasarkan ID
  Future<User?> getUserById(int id) async {
    final maps = await _databaseHelper.query(
      DatabaseConstants.usersTable,
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    
    return null;
  }

  /// Menyimpan user (insert atau update)
  Future<int> saveUser(User user) async {
    if (user.id == null) {
      return await _databaseHelper.insert(
        DatabaseConstants.usersTable,
        user.toMap(),
      );
    } else {
      return await _databaseHelper.update(
        DatabaseConstants.usersTable,
        user.toMap(),
        '${DatabaseConstants.colId} = ?',
        [user.id],
      );
    }
  }

  /// Menghapus user
  Future<int> deleteUser(int id) async {
    return await _databaseHelper.delete(
      DatabaseConstants.usersTable,
      '${DatabaseConstants.colId} = ?',
      [id],
    );
  }

  /// Mencari user berdasarkan nama
  Future<List<User>> searchUsers(String query) async {
    final maps = await _databaseHelper.query(
      DatabaseConstants.usersTable,
      where: '${DatabaseConstants.colUserName} LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: '${DatabaseConstants.colUserName} ASC',
    );
    
    return maps.map((map) => User.fromMap(map)).toList();
  }

  /// Mendapatkan jumlah total user
  Future<int> getUserCount() async {
    final result = await _databaseHelper.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseConstants.usersTable}',
    );
    
    return result.first['count'] as int;
  }
}
