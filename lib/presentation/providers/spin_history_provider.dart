import 'package:flutter/material.dart';
import 'package:spin_wheels/data/models/spin_history_model.dart';
import 'package:spin_wheels/domain/repositories/spin_history_repository.dart';

/// Provider untuk mengelola state terkait SpinHistory
class SpinHistoryProvider extends ChangeNotifier {
  final SpinHistoryRepository _spinHistoryRepository = SpinHistoryRepository();
  
  List<SpinHistory> _spinHistories = [];
  Map<String, dynamic> _statistics = {};
  bool _isLoading = false;
  String? _error;

  /// Getter untuk mendapatkan daftar riwayat spin
  List<SpinHistory> get spinHistories => _spinHistories;
  
  /// Getter untuk mendapatkan statistik
  Map<String, dynamic> get statistics => _statistics;
  
  /// Getter untuk mendapatkan status loading
  bool get isLoading => _isLoading;
  
  /// Getter untuk mendapatkan error
  String? get error => _error;
  
  /// Getter untuk mendapatkan jumlah hadiah yang belum terkirim
  int get unsentCount => _statistics['unsentCount'] ?? 0;

  /// Memuat semua riwayat spin dari database
  Future<void> loadSpinHistories() async {
    _setLoading(true);
    try {
      _spinHistories = await _spinHistoryRepository.getSpinHistories();
      _error = null;
    } catch (e) {
      _error = 'Gagal memuat riwayat spin: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  /// Memuat riwayat spin berdasarkan ID user
  Future<void> loadSpinHistoriesByUserId(int userId) async {
    _setLoading(true);
    try {
      _spinHistories = await _spinHistoryRepository.getSpinHistoriesByUserId(userId);
      _error = null;
    } catch (e) {
      _error = 'Gagal memuat riwayat spin: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  /// Menyimpan riwayat spin baru
  Future<bool> saveSpinHistory(SpinHistory spinHistory) async {
    _setLoading(true);
    try {
      final id = await _spinHistoryRepository.saveSpinHistory(spinHistory);
      if (id > 0) {
        await loadSpinHistories();
        await loadStatistics();
        return true;
      }
      _error = 'Gagal menyimpan riwayat spin';
      return false;
    } catch (e) {
      _error = 'Gagal menyimpan riwayat spin: ${e.toString()}';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Menandai riwayat spin sebagai terkirim
  Future<bool> markAsSent(int spinHistoryId, {String? notes}) async {
    _setLoading(true);
    try {
      final result = await _spinHistoryRepository.markAsSent(spinHistoryId, notes: notes);
      if (result > 0) {
        await loadSpinHistories();
        await loadStatistics();
        return true;
      }
      _error = 'Gagal menandai hadiah sebagai terkirim';
      return false;
    } catch (e) {
      _error = 'Gagal menandai hadiah sebagai terkirim: ${e.toString()}';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Memuat statistik riwayat spin
  Future<void> loadStatistics() async {
    _setLoading(true);
    try {
      _statistics = await _spinHistoryRepository.getSpinStatistics();
      _error = null;
    } catch (e) {
      _error = 'Gagal memuat statistik: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  /// Reset error
  void resetError() {
    _error = null;
    notifyListeners();
  }

  /// Set status loading dan notifikasi listeners
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
