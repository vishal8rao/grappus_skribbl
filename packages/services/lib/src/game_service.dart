import 'dart:io';

import 'package:dio/dio.dart';
import 'package:services/src/endpoints.dart';

class GameService {
  final dioClient = Dio(BaseOptions(
      baseUrl: Endpoints.baseUrl,
      responseType: ResponseType.json,
      headers: {Headers.contentTypeHeader: 'application/json'}));

  Future<Response> connect() async {
    var future = await dioClient.get('/connect');
    return future;
  }
}
