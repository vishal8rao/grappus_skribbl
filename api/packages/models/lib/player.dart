// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Player {
  String userId;
  String name;
  final bool hasAnsweredCorrectly;

  Player({
    required this.userId,
    required this.name,
    this.hasAnsweredCorrectly = false,
  });

  Player copyWith({
    String? userId,
    String? name,
    bool? hasAnsweredCorrectly,
  }) {
    return Player(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      hasAnsweredCorrectly: hasAnsweredCorrectly ?? this.hasAnsweredCorrectly,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'name': name,
      'hasAnsweredCorrectly': hasAnsweredCorrectly,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      userId: map['userId'] as String,
      name: map['name'] as String,
      hasAnsweredCorrectly: (map['hasAnsweredCorrectly'] ?? false) as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Player.fromJson(String source) =>
      Player.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
