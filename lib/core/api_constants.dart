import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const baseUrl = "http://digitolk.liveplaygrounds.com/api";

// const String PUSHER_APP_KEY = "3f4c73c6334ed62f0d32";
const String PUSHER_APP_KEY = "1a62105181a4f7b62bff";

Future<Map<String, String>> getHeaders(
    {String? contentType = 'application/json'}) async {
  String? token = await const FlutterSecureStorage().read(key: 'token');

  Map<String, String> header = {};

  if (contentType != null) {
    header.putIfAbsent("Content-Type", () => contentType);
  }

  header.putIfAbsent("Accept", () => "application/json");

  if (token != null) {
    header.putIfAbsent(HttpHeaders.authorizationHeader, () => "Bearer $token");
  }

  return header;
}
