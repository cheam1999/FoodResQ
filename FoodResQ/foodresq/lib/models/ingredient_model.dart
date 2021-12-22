import 'dart:convert';

class Ingredient {
  final int id;
  final String ingredientName;
  final String? expiryDate;
  Ingredient({
    required this.id,
    required this.ingredientName,
    required this.expiryDate,
  });

  Ingredient copyWith({
    int? id,
    String? ingredientName,
    String? expiryDate,
  }) {
    return Ingredient(
      id: id ?? this.id,
      ingredientName: ingredientName ?? this.ingredientName,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ingredientName': ingredientName,
      'expiryDate': expiryDate,
    };
  }

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      id: checkAndReturnInt(map['id']),
      ingredientName: map['ingredientName'],
      expiryDate: map['expiryDate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Ingredient.fromJson(String source) =>
      Ingredient.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Ingredient(id: $id, ingredientName: $ingredientName, expiryDate: $expiryDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Ingredient &&
        other.id == id &&
        other.ingredientName == ingredientName &&
        other.expiryDate == expiryDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^ ingredientName.hashCode ^ expiryDate.hashCode;
  }
}

int checkAndReturnInt(dynamic value) {
  if (value is int) return value;
  String str = value;
  return int.parse(str);
}
