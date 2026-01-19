import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/constants.dart';
import '../models/user_model.dart';
import 'dart:convert';

class AuthService {
  final storage = const FlutterSecureStorage();

  Future<UserModel?> getCurrentUser() async {
    try {
      final userString = await storage.read(key: AppConstants.userKey);
      if (userString != null) {
        final userData = jsonDecode(userString);
        return UserModel.fromJson(userData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await storage.read(key: AppConstants.tokenKey);
    return token != null;
  }

  Future<void> logout() async {
    await storage.delete(key: AppConstants.tokenKey);
    await storage.delete(key: AppConstants.userKey);
  }
}
