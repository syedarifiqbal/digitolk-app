import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  static FlutterSecureStorage instance = new FlutterSecureStorage();

  static void set(key, value) async {
    await instance.write(key: key, value: value);
  }

  static Future<String?> get(key) async {
    return await instance.read(key: key);
  }
}
