import 'dart:convert';

import 'package:digitolk_test/core/api_constants.dart';
import 'package:digitolk_test/models/user.dart';
import 'package:http/http.dart';

class AuthService {
  static Future<User> login({
    required String email,
    required String password,
  }) async {
    Response res = await post(
      Uri.parse('$baseUrl/auth/login'),
      body: <String, String>{
        'email': email,
        'password': password,
      },
    );

    if (res.statusCode >= 400 && res.statusCode < 500) {
      throw Exception('Invalid Credentials!');
    }

    if (res.statusCode != 200) {
      throw Exception(res.body.toString());
    }

    return User.fromJson(jsonDecode(res.body));
  }

  static Future<Map<String, dynamic>> register({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    Response res =
        await post(Uri.parse('$baseUrl/auth/register'), body: <String, String>{
      'username': username,
      'name': name,
      'email': email,
      'password': password,
    });

    if (res.statusCode != 200) {
      throw Exception(res.body.toString());
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> logout() async {
    Response res = await post(Uri.parse('$baseUrl/auth/logout'),
        headers: await getHeaders());

    if (res.statusCode != 200) {
      throw Exception(res.body.toString());
    }

    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<User> me() async {
    Response res =
        await get(Uri.parse('$baseUrl/user'), headers: await getHeaders());

    if (res.statusCode != 200) {
      throw Exception(res.body.toString());
    }

    return User.fromJson(jsonDecode(res.body));
  }
}
