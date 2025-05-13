import 'package:flutter/material.dart';
import 'package:spin_wheels/config/app_config.dart';

/// Model data untuk Prize (Hadiah)
class Prize {
  final int? id;
  final String name;
  final String? description;
  final double? value;
  final Color color;
  final double? probability;
  final int availableCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Prize({
    this.id,
    required this.name,
    this.description,
    this.value,
    required this.color,
    this.probability,
    required this.availableCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Membuat Prize dari Map (dari database)
  factory Prize.fromMap(Map<String, dynamic> map) {
    return Prize(
      id: map[DatabaseConstants.colId],
      name: map[DatabaseConstants.colPrizeName],
      description: map[DatabaseConstants.colPrizeDescription],
      value: map[DatabaseConstants.colPrizeValue],
      color: Color(int.parse(map[DatabaseConstants.colPrizeColor])),
      probability: map[DatabaseConstants.colPrizeProbability],
      availableCount: map[DatabaseConstants.colPrizeAvailableCount],
      createdAt: DateTime.parse(map[DatabaseConstants.colCreatedAt]),
      updatedAt: DateTime.parse(map[DatabaseConstants.colUpdatedAt]),
    );
  }

  /// Konversi Prize ke Map (untuk database)
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      DatabaseConstants.colPrizeName: name,
      DatabaseConstants.colPrizeDescription: description,
      DatabaseConstants.colPrizeValue: value,
      DatabaseConstants.colPrizeColor: color.value.toString(),
      DatabaseConstants.colPrizeProbability: probability,
      DatabaseConstants.colPrizeAvailableCount: availableCount,
      DatabaseConstants.colCreatedAt: createdAt.toIso8601String(),
      DatabaseConstants.colUpdatedAt: updatedAt.toIso8601String(),
    };

    if (id != null) {
      map[DatabaseConstants.colId] = id;
    }

    return map;
  }

  /// Membuat salinan Prize dengan nilai yang diperbarui
  Prize copyWith({
    int? id,
    String? name,
    String? description,
    double? value,
    Color? color,
    double? probability,
    int? availableCount,
    String? imagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Prize(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      value: value ?? this.value,
      color: color ?? this.color,
      probability: probability ?? this.probability,
      availableCount: availableCount ?? this.availableCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'Prize(id: $id, name: $name, value: $value, availableCount: $availableCount)';
  }
}
