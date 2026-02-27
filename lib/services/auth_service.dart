import '../config/constants.dart';
import '../models/user_model.dart';
import 'dart:convert';
import 'storage_service.dart';

class AuthService {
  final storage = StorageService();

  Future<UserModel?> getCurrentUser() async {
    try {
      final userString = await storage.read(AppConstants.userKey);
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
    final token = await storage.read(AppConstants.tokenKey);
    return token != null;
  }

  Future<void> logout() async {
    await storage.delete(AppConstants.tokenKey);
    await storage.delete(AppConstants.userKey);
  }
}
