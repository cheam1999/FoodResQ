import 'dart:convert';

class ConsumedIngredient {
  final int id;
  final String ingredientName;
  final String? expiryDate;
  ConsumedIngredient({
    required this.id,
    required this.ingredientName,
    required this.expiryDate,
  });

  ConsumedIngredient copyWith({
    int? id,
    String? ingredientName,
    String? expiryDate,
  }) {
    return ConsumedIngredient(
      id: id ?? this.id,
      ingredientName: ingredientName ?? this.ingredientName,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ingredient_name': ingredientName,
      'expiry_date': expiryDate,
    };
  }

  factory ConsumedIngredient.fromMap(Map<String, dynamic> map) {
    return ConsumedIngredient(
      id: checkAndReturnInt(map['id']),
      ingredientName: map['ingredient_name'],
      expiryDate: map['expiry_date'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ConsumedIngredient.fromJson(String source) =>
      ConsumedIngredient.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Ingredient(id: $id, ingredientName: $ingredientName, expiryDate: $expiryDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConsumedIngredient &&
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
