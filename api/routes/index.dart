import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  return Response(
    body: File('public/index.html').readAsStringSync(),
    headers: {HttpHeaders.contentTypeHeader: ContentType.html.value},
  );
}
