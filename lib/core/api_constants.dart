import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const baseUrl = "http://10.0.2.2:8000/api";

Future<Map<String, String>> getHeaders(
    {String? contentType = 'application/json'}) async {
  String? token = await const FlutterSecureStorage().read(key: 'token');

  Map<String, String> header = {};

  if (contentType != null) {
    header.putIfAbsent("Content-Type", () => contentType);
  }

  if (token != null) {
    header.putIfAbsent(HttpHeaders.authorizationHeader, () => "Bearer $token");
  }

  return header;
}
