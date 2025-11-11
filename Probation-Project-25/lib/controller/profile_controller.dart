import 'package:flutter/material.dart';
import 'package:mind_ease_app/model/user_model.dart';
import 'package:mind_ease_app/services/api/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController {
  Future<bool> updateProfile({
    required UserModel user,
    required String phone,
    required String gender,
    required String age,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final userId = prefs.getString('userId') ?? '';

      final data = {
        "_id": userId,
        "name": user.name ?? "",
        "email": user.email,
        "phone": phone,
        "gender": gender,
        "age": age,
      };

      final authService = AuthService();
      final response = await authService.putRequest(
        '/edit',
        data,
        token: token, 
      );
      
      if (response['success'] == true ||
      response['message']?.toString().toLowerCase().contains('updated') == true ||
      response['_id'] != null) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint(" Error updating profile: $e");
      return false;
    }
  }
}
