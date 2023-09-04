// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:models/src/web_socket_event.dart';

class WebSocketResponse {
  final String status;
  final Map<String, dynamic> data;
  final EventType eventType;
  final String? message;
  WebSocketResponse({
    required this.data,
    required this.eventType,
    this.status = 'success',
    this.message,
  });

  String encodedJson() {
    return jsonEncode(
      {
        'status': status,
        'data': data,
        'eventType': eventType.name,
        'message': message,
      },
    );
  }

  factory WebSocketResponse.fromMap(Map<String, dynamic> map) {
    return WebSocketResponse(
      status: map['status'].toString(),
      data: map['data'] as Map<String, dynamic>,
      message: map['message'].toString(),
      eventType: EventType.values.firstWhere(
        (element) => element.name == map['eventType'],
        orElse: () => EventType.invalid,
      ),
    );
  }
}
