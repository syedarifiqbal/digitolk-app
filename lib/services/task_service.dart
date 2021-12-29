import 'dart:convert';

import 'package:digitolk_test/core/api_constants.dart';
import 'package:digitolk_test/models/task.dart';
import 'package:digitolk_test/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class TaskService {
  static Future<List<Task>> fetch() async {
    Response res =
        await get(Uri.parse('$baseUrl/tasks'), headers: await getHeaders());

    if (res.statusCode >= 400 && res.statusCode < 500) {
      throw Exception('Something went wrong!');
    }

    if (res.statusCode != 200) {
      throw Exception(res.body.toString());
    }
    var response = jsonDecode(res.body);
    return response.map<Task>((value) => Task.fromJson(value)).toList();
    // return Task.fromJson();
  }

  static Future<List<Task>> toggleComplete(int id) async {
    Response res = await post(
      Uri.parse('$baseUrl/tasks/$id/toggle'),
      body: <String, dynamic>{"completed": '1', '_method': "PUT"},
      headers: await getHeaders(contentType: null),
    );

    if (res.statusCode != 200) {
      throw Exception(res.body.toString());
    }

    var response = jsonDecode(res.body);
    return response.map<Task>((value) => Task.fromJson(value)).toList();
  }

  static Future<List<Task>> deleteTask(int id) async {
    Response res = await delete(
      Uri.parse('$baseUrl/tasks/$id'),
      headers: await getHeaders(),
    );

    if (res.statusCode != 200) {
      throw Exception(res.body.toString());
    }

    var response = jsonDecode(res.body);
    return response.map<Task>((value) => Task.fromJson(value)).toList();
  }

  static Future<String> create(
      {required String summary,
      required String description,
      required String due_at}) async {
    final body = {
      "summary": summary,
      'description': description,
      'due_at': due_at,
    };

    Response res = await post(
      Uri.parse('$baseUrl/tasks'),
      body: jsonEncode(body),
      headers: await getHeaders(contentType: "application/json"),
    );

    if (res.statusCode != 201) {
      throw Exception(res.body.toString());
    }

    var response = jsonDecode(res.body);

    return response['message'];
  }
}
