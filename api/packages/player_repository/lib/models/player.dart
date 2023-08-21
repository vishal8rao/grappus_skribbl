// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'player.g.dart';

@JsonSerializable()
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

  /// Deserializes the given `Map<String, dynamic>` into a [Player].
  static Player fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  /// Converts this [Player] into a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$PlayerToJson(this);
}
