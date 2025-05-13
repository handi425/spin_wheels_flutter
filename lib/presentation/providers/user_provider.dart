import 'package:flutter/material.dart';
import 'package:spin_wheels/data/models/user_model.dart';
import 'package:spin_wheels/domain/repositories/user_repository.dart';

/// Provider untuk mengelola state terkait User
class UserProvider extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  
  List<User> _users = [];
  bool _isLoading = false;
  String? _error;
  User? _selectedUser;

  /// Getter untuk mendapatkan daftar user
  List<User> get users => _users;
  
  /// Getter untuk mendapatkan status loading
  bool get isLoading => _isLoading;
  
  /// Getter untuk mendapatkan error
  String? get error => _error;
  
  /// Getter untuk mendapatkan user yang dipilih
  User? get selectedUser => _selectedUser;

  /// Memuat semua user dari database
  Future<void> loadUsers() async {
    _setLoading(true);
    try {
      _users = await _userRepository.getUsers();
      _error = null;
    } catch (e) {
      _error = 'Gagal memuat data pengguna: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  /// Memilih user berdasarkan ID
  Future<void> selectUser(int userId) async {
    _setLoading(true);
    try {
      _selectedUser = await _userRepository.getUserById(userId);
      _error = null;
    } catch (e) {
      _error = 'Gagal memilih pengguna: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  /// Menyimpan user baru atau memperbarui user yang ada
  Future<bool> saveUser(User user) async {
    _setLoading(true);
    try {
      final id = await _userRepository.saveUser(user);
      if (id > 0) {
        await loadUsers();
        return true;
      }
      _error = 'Gagal menyimpan pengguna';
      return false;
    } catch (e) {
      _error = 'Gagal menyimpan pengguna: ${e.toString()}';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Menghapus user berdasarkan ID
  Future<bool> deleteUser(int userId) async {
    _setLoading(true);
    try {
      final result = await _userRepository.deleteUser(userId);
      if (result > 0) {
        await loadUsers();
        if (_selectedUser?.id == userId) {
          _selectedUser = null;
        }
        return true;
      }
      _error = 'Gagal menghapus pengguna';
      return false;
    } catch (e) {
      _error = 'Gagal menghapus pengguna: ${e.toString()}';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Mencari user berdasarkan query
  Future<void> searchUsers(String query) async {
    _setLoading(true);
    try {
      if (query.isEmpty) {
        await loadUsers();
      } else {
        _users = await _userRepository.searchUsers(query);
      }
      _error = null;
    } catch (e) {
      _error = 'Gagal mencari pengguna: ${e.toString()}';
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
