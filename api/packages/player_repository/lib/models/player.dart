// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Player {
  final String userId;
  final String name;

  Player({
    required this.userId,
    required this.name,
  });

  Player copyWith({
    String? userId,
    String? name,
  }) {
    return Player(
      userId: userId ?? this.userId,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'name': name,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      userId: map['userId'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Player.fromJson(String source) =>
      Player.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'User(name: $name)';
}
