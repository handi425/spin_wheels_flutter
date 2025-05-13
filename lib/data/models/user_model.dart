import 'package:spin_wheels/config/app_config.dart';

/// Model data untuk User
class User {
  final int? id;
  final String name;
  final String? email;
  final String? phone;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    this.id,
    required this.name,
    this.email,
    this.phone,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Membuat User dari Map (dari database)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map[DatabaseConstants.colId],
      name: map[DatabaseConstants.colUserName],
      email: map[DatabaseConstants.colUserEmail],
      phone: map[DatabaseConstants.colUserPhone],
      createdAt: DateTime.parse(map[DatabaseConstants.colCreatedAt]),
      updatedAt: DateTime.parse(map[DatabaseConstants.colUpdatedAt]),
    );
  }

  /// Konversi User ke Map (untuk database)
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      DatabaseConstants.colUserName: name,
      DatabaseConstants.colUserEmail: email,
      DatabaseConstants.colUserPhone: phone,
      DatabaseConstants.colCreatedAt: createdAt.toIso8601String(),
      DatabaseConstants.colUpdatedAt: updatedAt.toIso8601String(),
    };

    if (id != null) {
      map[DatabaseConstants.colId] = id;
    }

    return map;
  }

  /// Membuat salinan User dengan nilai yang diperbarui
  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, phone: $phone)';
  }
}
