import 'dart:convert';

import 'package:api/session/bloc/session_bloc.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';
import 'package:uuid/uuid.dart';

Response onRequest(RequestContext context) {
  final uid = const Uuid().v4();

  return Response(
    body: jsonEncode({'status': 'success', 'data': uid}),
  );
}
