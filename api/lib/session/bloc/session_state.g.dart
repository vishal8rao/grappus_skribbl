// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionState _$SessionStateFromJson(Map<String, dynamic> json) => SessionState(
      playerId: json['playerId'] as String?,
      players: (json['players'] as List<dynamic>?)
              ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SessionStateToJson(SessionState instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'players': instance.players,
    };
