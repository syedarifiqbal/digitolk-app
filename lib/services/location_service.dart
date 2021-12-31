import 'dart:convert';

import 'package:digitolk_test/core/api_constants.dart';
import 'package:digitolk_test/models/location.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class LocationService {
  static Future<dynamic> fetch({String page = '1'}) async {
    Response res = await get(Uri.parse('$baseUrl/locations?page=$page'),
        headers: await getHeaders());

    if (res.statusCode >= 400 && res.statusCode < 500) {
      throw Exception('Something went wrong!');
    }

    if (res.statusCode != 200) {
      throw Exception(res.body.toString());
    }
    var response = jsonDecode(res.body);

    // print(response);

    return response;

    // return response.map<Location>((value) => Location.fromJson(value)).toList();
    // return Location.fromJson();
  }

  static Future<dynamic> getAddress(
      {required String lat, required String lng}) async {
    print('$baseUrl/locations/$lat/$lng?app=1');

    Response res = await get(
      Uri.parse('$baseUrl/locations/$lat/$lng?app=1'),
    );

    if (res.statusCode >= 400 && res.statusCode < 500) {
      throw Exception('Something went wrong!');
    }

    if (res.statusCode != 200) {
      throw Exception(res.body.toString());
    }
    return (res.body);
    // return response.map<Location>((value) => Location.fromJson(value)).toList();
    // return Location.fromJson();
  }

  static Future<String> deleteLocation(int id) async {
    Response res = await delete(
      Uri.parse('$baseUrl/locations/$id'),
      headers: await getHeaders(),
    );

    if (res.statusCode != 200) {
      throw Exception(res.body.toString());
    }

    var response = jsonDecode(res.body);
    return response['message'];
  }

  static Future<String> create(
      {required String location,
      required String lat,
      required String lng}) async {
    final body = {
      "location": location,
      'lat': lat,
      'lng': lng,
    };
    Response res = await post(
      Uri.parse('$baseUrl/locations'),
      body: jsonEncode(body),
      headers: await getHeaders(),
    );

    if (res.statusCode != 201) {
      throw Exception(res.body.toString());
    }

    var response = jsonDecode(res.body);

    return "Created success";
  }

  static Future<String> editLocation(
      {required int id,
      required String location,
      required String lat,
      required String lng}) async {
    final body = {
      "location": location,
      'lat': lat,
      'lng': lng,
      '_method': "PUT",
    };

    Response res = await post(
      Uri.parse('$baseUrl/locations/$id'),
      body: jsonEncode(body),
      headers: await getHeaders(),
    );

    print(res.body);

    if (res.statusCode != 200) {
      throw Exception(res.body.toString());
    }

    var response = jsonDecode(res.body);

    return "Updated success";
  }
}
