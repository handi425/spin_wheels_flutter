import 'package:spin_wheels/config/app_config.dart';

/// Model data untuk User
class User {
  final int? id;
  final String name;
  final String? email;
  final String? phone;
  final String? address;
  final String? invoice;
  final String? trackingNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    this.id,
    required this.name,
    this.email,
    this.phone,
    this.address,
    this.invoice,
    this.trackingNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  /// Membuat User dari Map (dari database)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map[DatabaseConstants.colId],
      name: map[DatabaseConstants.colUserName],
      email: map[DatabaseConstants.colUserEmail],
      phone: map[DatabaseConstants.colUserPhone],
      address: map[DatabaseConstants.colUserAddress],
      invoice: map[DatabaseConstants.colUserInvoice],
      trackingNumber: map[DatabaseConstants.colUserTrackingNumber],
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
      DatabaseConstants.colUserAddress: address,
      DatabaseConstants.colUserInvoice: invoice,
      DatabaseConstants.colUserTrackingNumber: trackingNumber,
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
    String? address,
    String? invoice,
    String? trackingNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      invoice: invoice ?? this.invoice,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, phone: $phone, address: $address, invoice: $invoice, trackingNumber: $trackingNumber)';
  }
}
