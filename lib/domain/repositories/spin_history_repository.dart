import 'package:spin_wheels/config/app_config.dart';
import 'package:spin_wheels/data/db/database_helper.dart';
import 'package:spin_wheels/data/models/spin_history_model.dart';

/// Repository untuk mengakses dan mengelola data SpinHistory
class SpinHistoryRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  /// Mendapatkan semua riwayat spin
  Future<List<SpinHistory>> getSpinHistories() async {
    final query = '''
      SELECT 
        h.*, 
        u.${DatabaseConstants.colUserName} as user_name,
        u.${DatabaseConstants.colUserEmail} as user_email,
        p.${DatabaseConstants.colPrizeName} as prize_name,
        p.${DatabaseConstants.colPrizeValue} as prize_value
      FROM ${DatabaseConstants.spinHistoryTable} h
      JOIN ${DatabaseConstants.usersTable} u ON h.${DatabaseConstants.colSpinHistoryUserId} = u.${DatabaseConstants.colId}
      JOIN ${DatabaseConstants.prizesTable} p ON h.${DatabaseConstants.colSpinHistoryPrizeId} = p.${DatabaseConstants.colId}
      ORDER BY h.${DatabaseConstants.colCreatedAt} DESC
    ''';

    final maps = await _databaseHelper.rawQuery(query);

    return maps.map((map) => SpinHistory.fromMap(map)).toList();
  }

  /// Mendapatkan riwayat spin berdasarkan ID
  Future<SpinHistory?> getSpinHistoryById(int id) async {
    final query = '''
      SELECT 
        h.*, 
        u.${DatabaseConstants.colUserName} as user_name,
        u.${DatabaseConstants.colUserEmail} as user_email,
        p.${DatabaseConstants.colPrizeName} as prize_name,
        p.${DatabaseConstants.colPrizeValue} as prize_value
      FROM ${DatabaseConstants.spinHistoryTable} h
      JOIN ${DatabaseConstants.usersTable} u ON h.${DatabaseConstants.colSpinHistoryUserId} = u.${DatabaseConstants.colId}
      JOIN ${DatabaseConstants.prizesTable} p ON h.${DatabaseConstants.colSpinHistoryPrizeId} = p.${DatabaseConstants.colId}
      WHERE h.${DatabaseConstants.colId} = ?
    ''';

    final maps = await _databaseHelper.rawQuery(query, [id]);

    if (maps.isNotEmpty) {
      return SpinHistory.fromMap(maps.first);
    }

    return null;
  }

  /// Mendapatkan riwayat spin berdasarkan user ID
  Future<List<SpinHistory>> getSpinHistoriesByUserId(int userId) async {
    final query = '''
      SELECT 
        h.*, 
        u.${DatabaseConstants.colUserName} as user_name,
        u.${DatabaseConstants.colUserEmail} as user_email,
        p.${DatabaseConstants.colPrizeName} as prize_name,
        p.${DatabaseConstants.colPrizeValue} as prize_value
      FROM ${DatabaseConstants.spinHistoryTable} h
      JOIN ${DatabaseConstants.usersTable} u ON h.${DatabaseConstants.colSpinHistoryUserId} = u.${DatabaseConstants.colId}
      JOIN ${DatabaseConstants.prizesTable} p ON h.${DatabaseConstants.colSpinHistoryPrizeId} = p.${DatabaseConstants.colId}
      WHERE h.${DatabaseConstants.colSpinHistoryUserId} = ?
      ORDER BY h.${DatabaseConstants.colCreatedAt} DESC
    ''';

    final maps = await _databaseHelper.rawQuery(query, [userId]);

    return maps.map((map) => SpinHistory.fromMap(map)).toList();
  }

  /// Menyimpan riwayat spin (insert)
  Future<int> saveSpinHistory(SpinHistory spinHistory) async {
    return await _databaseHelper.insert(
      DatabaseConstants.spinHistoryTable,
      spinHistory.toMap(),
    );
  }

  /// Menandai riwayat spin sebagai terkirim
  Future<int> markAsSent(
    int id, {
    String? notes,
    String? trackingNumber,
  }) async {
    final now = DateTime.now();
    final map = {
      DatabaseConstants.colSpinHistoryIsSent: 1,
      DatabaseConstants.colSpinHistorySentAt: now.toIso8601String(),
    };

    if (notes != null) {
      map[DatabaseConstants.colSpinHistoryNotes] = notes;
    }

    if (trackingNumber != null) {
      map[DatabaseConstants.colSpinHistoryTrackingNumber] = trackingNumber;
    }

    return await _databaseHelper.update(
      DatabaseConstants.spinHistoryTable,
      map,
      '${DatabaseConstants.colId} = ?',
      [id],
    );
  }

  /// Mendapatkan jumlah riwayat spin yang belum terkirim
  Future<int> getUnsentCount() async {
    final result = await _databaseHelper.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseConstants.spinHistoryTable} WHERE ${DatabaseConstants.colSpinHistoryIsSent} = 0',
    );

    return result.first['count'] as int;
  }

  /// Mendapatkan statistik riwayat spin
  Future<Map<String, dynamic>> getSpinStatistics() async {
    // Jumlah total spin
    final totalCountResult = await _databaseHelper.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseConstants.spinHistoryTable}',
    );
    final totalCount = totalCountResult.first['count'] as int;

    // Jumlah hadiah yang sudah terkirim
    final sentCountResult = await _databaseHelper.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseConstants.spinHistoryTable} WHERE ${DatabaseConstants.colSpinHistoryIsSent} = 1',
    );
    final sentCount = sentCountResult.first['count'] as int;

    // Jumlah hadiah berdasarkan jenisnya
    final prizeDistributionResult = await _databaseHelper.rawQuery('''
      SELECT 
        p.${DatabaseConstants.colPrizeName} as name,
        COUNT(*) as count
      FROM ${DatabaseConstants.spinHistoryTable} h
      JOIN ${DatabaseConstants.prizesTable} p ON h.${DatabaseConstants.colSpinHistoryPrizeId} = p.${DatabaseConstants.colId}
      GROUP BY h.${DatabaseConstants.colSpinHistoryPrizeId}
      ORDER BY count DESC
    ''');

    // Jumlah spin per user
    final userSpinCountResult = await _databaseHelper.rawQuery('''
      SELECT 
        u.${DatabaseConstants.colUserName} as name,
        COUNT(*) as count
      FROM ${DatabaseConstants.spinHistoryTable} h
      JOIN ${DatabaseConstants.usersTable} u ON h.${DatabaseConstants.colSpinHistoryUserId} = u.${DatabaseConstants.colId}
      GROUP BY h.${DatabaseConstants.colSpinHistoryUserId}
      ORDER BY count DESC
    ''');

    return {
      'totalCount': totalCount,
      'sentCount': sentCount,
      'unsentCount': totalCount - sentCount,
      'prizeDistribution': prizeDistributionResult,
      'userSpinCount': userSpinCountResult,
    };
  }
}
