import 'dart:convert';

//TODO: please fix repeat isLogin return null from API
class User {
  final int? id;
  final String? name;
  final String? email;
  final String? accessToken;
  final String? createdAt;
  final String? updatedAt;
  final String? tokenType;
  final bool isLogin;
  User({
    this.id,
    this.name,
    this.email,
    this.accessToken,
    this.createdAt,
    this.updatedAt,
    this.tokenType,
    this.isLogin = false,
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? accessToken,
    String? createdAt,
    String? updatedAt,
    String? tokenType,
    bool? isLogin,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      accessToken: accessToken ?? this.accessToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tokenType: tokenType ?? this.tokenType,
      isLogin: isLogin ?? this.isLogin,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'accessToken': accessToken,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'tokenType': tokenType,
      'isLogin': isLogin,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] != null ? checkAndReturnInt(map['id']) : null,
      name: map['name'] != null ? map['name'] : null,
      email: map['email'] != null ? map['email'] : null,
      accessToken: map['accessToken'] != null ? map['accessToken'] : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] : null,
      tokenType: map['tokenType'] != null ? map['tokenType'] : null,
      isLogin: map['isLogin'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.accessToken == accessToken &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.tokenType == tokenType &&
        other.isLogin == isLogin;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        accessToken.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        tokenType.hashCode ^
        isLogin.hashCode;
  }
}

int checkAndReturnInt(dynamic value) {
    if (value is int) 
      return value;
    String str = value;
    return int.parse(str);
  }