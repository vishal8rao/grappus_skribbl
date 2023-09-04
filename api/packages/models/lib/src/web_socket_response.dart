// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:models/src/web_socket_event.dart';

class WebSocketResponse {
  final String status;
  final Map<String, dynamic> data;
  final EventType eventType;
  WebSocketResponse({
    required this.data,
    required this.eventType,
    this.status = 'success',
  });

  String encodedJson() {
    return jsonEncode(
      {'status': status, 'data': data, 'eventType': eventType.name},
    );
  }

  factory WebSocketResponse.fromMap(Map<String, dynamic> map) {
    return WebSocketResponse(
      status: map['status'].toString(),
      data: map['data'] as Map<String, dynamic>,
      eventType: EventType.values.firstWhere(
        (element) => element.name == map['eventType'],
        orElse: () => EventType.invalid,
      ),
    );
  }
}
