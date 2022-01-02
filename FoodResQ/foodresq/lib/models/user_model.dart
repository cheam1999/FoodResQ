import 'dart:convert';

//TODO: please fix repeat isLogin return null from API
class User {
  final int? id;
  final String? fullname;
  final String? email;
  final String? accessToken;
  final String? createdAt;
  final String? updatedAt;
  final String? tokenType;
  final bool isLogin;
  User({
    this.id,
    this.fullname,
    this.email,
    this.accessToken,
    this.createdAt,
    this.updatedAt,
    this.tokenType,
    this.isLogin = false,
  });

  User copyWith({
    int? id,
    String? fullname,
    String? email,
    String? accessToken,
    String? createdAt,
    String? updatedAt,
    String? tokenType,
    bool? isLogin,
  }) {
    return User(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
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
      'fullname': fullname,
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
      fullname: map['fullname'] != null ? map['fullname'] : null,
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
        other.fullname == fullname &&
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
        fullname.hashCode ^
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