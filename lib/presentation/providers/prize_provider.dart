import 'package:flutter/material.dart';
import 'package:spin_wheels/data/models/prize_model.dart';
import 'package:spin_wheels/domain/repositories/prize_repository.dart';

/// Provider untuk mengelola state terkait Prize
class PrizeProvider extends ChangeNotifier {
  final PrizeRepository _prizeRepository = PrizeRepository();
  
  List<Prize> _prizes = [];
  List<Prize> _availablePrizes = [];
  bool _isLoading = false;
  String? _error;
  Prize? _selectedPrize;

  /// Getter untuk mendapatkan daftar hadiah
  List<Prize> get prizes => _prizes;
  
  /// Getter untuk mendapatkan daftar hadiah yang tersedia
  List<Prize> get availablePrizes => _availablePrizes;
  
  /// Getter untuk mendapatkan status loading
  bool get isLoading => _isLoading;
  
  /// Getter untuk mendapatkan error
  String? get error => _error;
  
  /// Getter untuk mendapatkan hadiah yang dipilih
  Prize? get selectedPrize => _selectedPrize;

  /// Memuat semua hadiah dari database
  Future<void> loadPrizes({bool onlyAvailable = false}) async {
    _setLoading(true);
    try {
      _prizes = await _prizeRepository.getPrizes();
      
      if (onlyAvailable) {
        _availablePrizes = await _prizeRepository.getAvailablePrizes();
      } else {
        _availablePrizes = _prizes.where((prize) => prize.availableCount > 0).toList();
      }
      
      _error = null;
    } catch (e) {
      _error = 'Gagal memuat data hadiah: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  /// Memilih hadiah berdasarkan ID
  Future<void> selectPrize(int prizeId) async {
    _setLoading(true);
    try {
      _selectedPrize = await _prizeRepository.getPrizeById(prizeId);
      _error = null;
    } catch (e) {
      _error = 'Gagal memilih hadiah: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  /// Menyimpan hadiah baru atau memperbarui hadiah yang ada
  Future<bool> savePrize(Prize prize) async {
    _setLoading(true);
    try {
      final id = await _prizeRepository.savePrize(prize);
      if (id > 0) {
        await loadPrizes();
        return true;
      }
      _error = 'Gagal menyimpan hadiah';
      return false;
    } catch (e) {
      _error = 'Gagal menyimpan hadiah: ${e.toString()}';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Menghapus hadiah berdasarkan ID
  Future<bool> deletePrize(int prizeId) async {
    _setLoading(true);
    try {
      final result = await _prizeRepository.deletePrize(prizeId);
      if (result > 0) {
        await loadPrizes();
        if (_selectedPrize?.id == prizeId) {
          _selectedPrize = null;
        }
        return true;
      }
      _error = 'Gagal menghapus hadiah';
      return false;
    } catch (e) {
      _error = 'Gagal menghapus hadiah: ${e.toString()}';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Mengurangi jumlah hadiah yang tersedia
  Future<bool> decrementPrizeCount(int prizeId) async {
    _setLoading(true);
    try {
      final result = await _prizeRepository.decrementPrizeCount(prizeId);
      if (result > 0) {
        await loadPrizes();
        return true;
      }
      _error = 'Gagal mengurangi jumlah hadiah';
      return false;
    } catch (e) {
      _error = 'Gagal mengurangi jumlah hadiah: ${e.toString()}';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Mencari hadiah berdasarkan query
  Future<void> searchPrizes(String query) async {
    _setLoading(true);
    try {
      if (query.isEmpty) {
        await loadPrizes();
      } else {
        _prizes = await _prizeRepository.searchPrizes(query);
        _availablePrizes = _prizes.where((prize) => prize.availableCount > 0).toList();
      }
      _error = null;
    } catch (e) {
      _error = 'Gagal mencari hadiah: ${e.toString()}';
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
