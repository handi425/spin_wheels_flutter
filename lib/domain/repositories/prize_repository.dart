import 'package:spin_wheels/config/app_config.dart';
import 'package:spin_wheels/data/db/database_helper.dart';
import 'package:spin_wheels/data/models/prize_model.dart';

/// Repository untuk mengakses dan mengelola data Prize
class PrizeRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  /// Mendapatkan semua hadiah
  Future<List<Prize>> getPrizes() async {
    final maps = await _databaseHelper.query(
      DatabaseConstants.prizesTable,
      orderBy: '${DatabaseConstants.colPrizeName} ASC',
    );
    
    return maps.map((map) => Prize.fromMap(map)).toList();
  }

  /// Mendapatkan hadiah berdasarkan ID
  Future<Prize?> getPrizeById(int id) async {
    final maps = await _databaseHelper.query(
      DatabaseConstants.prizesTable,
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return Prize.fromMap(maps.first);
    }
    
    return null;
  }

  /// Menyimpan hadiah (insert atau update)
  Future<int> savePrize(Prize prize) async {
    if (prize.id == null) {
      return await _databaseHelper.insert(
        DatabaseConstants.prizesTable,
        prize.toMap(),
      );
    } else {
      return await _databaseHelper.update(
        DatabaseConstants.prizesTable,
        prize.toMap(),
        '${DatabaseConstants.colId} = ?',
        [prize.id],
      );
    }
  }

  /// Menghapus hadiah
  Future<int> deletePrize(int id) async {
    return await _databaseHelper.delete(
      DatabaseConstants.prizesTable,
      '${DatabaseConstants.colId} = ?',
      [id],
    );
  }

  /// Mencari hadiah berdasarkan nama
  Future<List<Prize>> searchPrizes(String query) async {
    final maps = await _databaseHelper.query(
      DatabaseConstants.prizesTable,
      where: '${DatabaseConstants.colPrizeName} LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: '${DatabaseConstants.colPrizeName} ASC',
    );
    
    return maps.map((map) => Prize.fromMap(map)).toList();
  }

  /// Mendapatkan hadiah yang tersedia (available_count > 0)
  Future<List<Prize>> getAvailablePrizes() async {
    final maps = await _databaseHelper.query(
      DatabaseConstants.prizesTable,
      where: '${DatabaseConstants.colPrizeAvailableCount} > 0',
      orderBy: '${DatabaseConstants.colPrizeName} ASC',
    );
    
    return maps.map((map) => Prize.fromMap(map)).toList();
  }

  /// Mengurangi jumlah hadiah yang tersedia
  Future<int> decrementPrizeCount(int id) async {
    final prize = await getPrizeById(id);
    if (prize != null && prize.availableCount > 0) {
      final updatedPrize = prize.copyWith(
        availableCount: prize.availableCount - 1,
        updatedAt: DateTime.now(),
      );
      
      return await savePrize(updatedPrize);
    }
    
    return 0;
  }

  /// Mendapatkan jumlah total hadiah
  Future<int> getPrizeCount() async {
    final result = await _databaseHelper.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseConstants.prizesTable}',
    );
    
    return result.first['count'] as int;
  }

  /// Mendapatkan total nilai hadiah
  Future<double> getTotalPrizeValue() async {
    final result = await _databaseHelper.rawQuery(
      'SELECT SUM(${DatabaseConstants.colPrizeValue}) as total FROM ${DatabaseConstants.prizesTable}',
    );
    
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }
}
