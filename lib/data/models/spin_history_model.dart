import 'package:spin_wheels/config/app_config.dart';

/// Model data untuk SpinHistory (Riwayat Putaran)
class SpinHistory {
  final int? id;
  final int userId;
  final int prizeId;
  final bool isSent;
  final DateTime? sentAt;
  final String? notes;
  final DateTime createdAt;
  
  // Data relasi (lazy loading)
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? _prizeData;

  SpinHistory({
    this.id,
    required this.userId,
    required this.prizeId,
    this.isSent = false,
    this.sentAt,
    this.notes,
    DateTime? createdAt,
    Map<String, dynamic>? userData,
    Map<String, dynamic>? prizeData,
  })  : createdAt = createdAt ?? DateTime.now(),
        _userData = userData,
        _prizeData = prizeData;

  /// Membuat SpinHistory dari Map (dari database)
  factory SpinHistory.fromMap(Map<String, dynamic> map) {
    return SpinHistory(
      id: map[DatabaseConstants.colId],
      userId: map[DatabaseConstants.colSpinHistoryUserId],
      prizeId: map[DatabaseConstants.colSpinHistoryPrizeId],
      isSent: map[DatabaseConstants.colSpinHistoryIsSent] == 1,
      sentAt: map[DatabaseConstants.colSpinHistorySentAt] != null
          ? DateTime.parse(map[DatabaseConstants.colSpinHistorySentAt])
          : null,
      notes: map[DatabaseConstants.colSpinHistoryNotes],
      createdAt: DateTime.parse(map[DatabaseConstants.colCreatedAt]),
      userData: map.containsKey('user_name') ? {
        'id': map['user_id'],
        'name': map['user_name'],
        'email': map['user_email'],
      } : null,
      prizeData: map.containsKey('prize_name') ? {
        'id': map['prize_id'],
        'name': map['prize_name'],
        'value': map['prize_value'],
      } : null,
    );
  }

  /// Konversi SpinHistory ke Map (untuk database)
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      DatabaseConstants.colSpinHistoryUserId: userId,
      DatabaseConstants.colSpinHistoryPrizeId: prizeId,
      DatabaseConstants.colSpinHistoryIsSent: isSent ? 1 : 0,
      DatabaseConstants.colSpinHistorySentAt: sentAt?.toIso8601String(),
      DatabaseConstants.colSpinHistoryNotes: notes,
      DatabaseConstants.colCreatedAt: createdAt.toIso8601String(),
    };

    if (id != null) {
      map[DatabaseConstants.colId] = id;
    }

    return map;
  }

  /// Mendapatkan data user
  Map<String, dynamic>? get userData => _userData;

  /// Mengatur data user
  set userData(Map<String, dynamic>? data) {
    _userData = data;
  }

  /// Mendapatkan data prize
  Map<String, dynamic>? get prizeData => _prizeData;

  /// Mengatur data prize
  set prizeData(Map<String, dynamic>? data) {
    _prizeData = data;
  }

  /// Membuat salinan SpinHistory dengan nilai yang diperbarui
  SpinHistory copyWith({
    int? id,
    int? userId,
    int? prizeId,
    bool? isSent,
    DateTime? sentAt,
    String? notes,
    DateTime? createdAt,
    Map<String, dynamic>? userData,
    Map<String, dynamic>? prizeData,
  }) {
    return SpinHistory(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      prizeId: prizeId ?? this.prizeId,
      isSent: isSent ?? this.isSent,
      sentAt: sentAt ?? this.sentAt,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      userData: userData ?? _userData,
      prizeData: prizeData ?? _prizeData,
    );
  }

  @override
  String toString() {
    final userName = _userData != null ? _userData!['name'] : 'Unknown';
    final prizeName = _prizeData != null ? _prizeData!['name'] : 'Unknown';
    return 'SpinHistory(id: $id, user: $userName, prize: $prizeName, isSent: $isSent)';
  }
}
