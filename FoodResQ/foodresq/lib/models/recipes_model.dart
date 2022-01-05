import 'dart:convert';

class Recipes {
  final int recipeID;
  final String recipeName;
  final String recipeImage;
  final String recipeLevel;
  final String recipeIngredients;
  final String recipeInstructions;
  final String recipeSource;
  final String recipeVideo;
  Recipes({
    required this.recipeID,
    required this.recipeName,
    required this.recipeImage,
    required this.recipeLevel,
    required this.recipeIngredients,
    required this.recipeInstructions,
    required this.recipeSource,
    required this.recipeVideo,
  });

  Recipes copyWith({
    int? recipeID,
    String? recipeName,
    String? recipeImage,
    String? recipeLevel,
    String? recipeIngredients,
    String? recipeInstructions,
    String? recipeSource,
    String? recipeVideo,
  }) {
    return Recipes(
      recipeID: recipeID ?? this.recipeID,
      recipeName: recipeName ?? this.recipeName,
      recipeImage: recipeImage ?? this.recipeImage,
      recipeLevel: recipeLevel ?? this.recipeLevel,
      recipeIngredients: recipeIngredients ?? this.recipeIngredients,
      recipeInstructions: recipeInstructions ?? this.recipeInstructions,
      recipeSource: recipeSource ?? this.recipeSource,
      recipeVideo: recipeVideo ?? this.recipeVideo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'recipeID': recipeID,
      'recipeName': recipeName,
      'recipeImage': recipeImage,
      'recipeLevel': recipeLevel,
      'recipeIngredients': recipeIngredients,
      'recipeInstructions': recipeInstructions,
      'recipeSource': recipeSource,
      'recipeVideo': recipeVideo,
    };
  }

  factory Recipes.fromMap(Map<String, dynamic> map) {
    return Recipes(
      recipeID: map['recipeID']?.toInt() ?? 0,
      recipeName: map['recipeName'] ?? '',
      recipeImage: map['recipeImage'] ?? '',
      recipeLevel: map['recipeLevel'] ?? '',
      recipeIngredients: map['recipeIngredients'] ?? '',
      recipeInstructions: map['recipeInstructions'] ?? '',
      recipeSource: map['recipeSource'] ?? '',
      recipeVideo: map['recipeVideo'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Recipes.fromJson(String source) =>
      Recipes.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Recipes(recipeID: $recipeID, recipeName: $recipeName, recipeImage: $recipeImage, recipeLevel: $recipeLevel, recipeIngredients: $recipeIngredients, recipeInstructions: $recipeInstructions, recipeSource: $recipeSource, recipeVideo: $recipeVideo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Recipes &&
        other.recipeID == recipeID &&
        other.recipeName == recipeName &&
        other.recipeImage == recipeImage &&
        other.recipeLevel == recipeLevel &&
        other.recipeIngredients == recipeIngredients &&
        other.recipeInstructions == recipeInstructions &&
        other.recipeSource == recipeSource &&
        other.recipeVideo == recipeVideo;
  }

  @override
  int get hashCode {
    return recipeID.hashCode ^
        recipeName.hashCode ^
        recipeImage.hashCode ^
        recipeLevel.hashCode ^
        recipeIngredients.hashCode ^
        recipeInstructions.hashCode ^
        recipeSource.hashCode ^
        recipeVideo.hashCode;
  }
}
