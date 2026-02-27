import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<String?> read(String key) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    }

    return _secureStorage.read(key: key);
  }

  Future<void> write(String key, String? value) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      if (value == null) {
        await prefs.remove(key);
      } else {
        await prefs.setString(key, value);
      }
      return;
    }

    if (value == null) {
      await _secureStorage.delete(key: key);
    } else {
      await _secureStorage.write(key: key, value: value);
    }
  }

  Future<void> delete(String key) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
      return;
    }

    await _secureStorage.delete(key: key);
  }
}
