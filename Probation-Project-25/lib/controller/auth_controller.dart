import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mind_ease_app/views/auth/profession_selection_overlay.dart';
 
import 'package:mind_ease_app/views/navbar/ai_therapist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api/auth_service.dart';

class AuthController {
  final AuthService _authService = AuthService();

  // LOGIN 
  Future<void> login(BuildContext context, String email, String password) async {
    try {
      final response = await _authService.login(email, password);
      Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['user'] != null && data['accessToken'] != null) {
        final user = data['user'];
        final token = data['accessToken'];
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('auth_token', token);
        print('Token saved: ${data['accessToken']}');
        await prefs.setString('user_name', user['name'] ?? '');
        await prefs.setString('user_email', user['email'] ?? '');
        await prefs.setString('user_id', user['id'] ?? '');
        await prefs.setBool('isLoggedIn', true);

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome back, ${user['name']}!')),
        );

        
        final profession = prefs.getString('profession');
        if (profession == null || profession.isEmpty) {
          
          Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const ProfessionSelectionOverlay()),
);
        } else {
          
          Navigator.pushReplacementNamed(context, 'home');
        }
      } else {
        final errorMsg = data['message'] ??
            data['error'] ??
            'Login failed. Please check your credentials.';
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMsg)));
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  //  SIGNUP 
  Future<void> signup(BuildContext context, String name, String email, String password) async {
    try {
      final response = await _authService.signup(name, email, password);
      debugPrint('Signup response status: ${response.statusCode}');
      debugPrint('Signup response body: ${response.body}');
      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', data['_id'] ?? '');
        await prefs.setString('user_name', data['name'] ?? name);
        await prefs.setString('user_email', data['email'] ?? email);

        final loginResponse = await _authService.login(email, password);
        final loginData = jsonDecode(loginResponse.body);

        if (loginResponse.statusCode == 200 &&
            (loginData['token'] != null || loginData['accessToken'] != null)) {
          final token = loginData['token'] ?? loginData['accessToken'];
          final user = loginData['user'];
          await prefs.setString('auth_token', token);
          if (user != null && user['_id'] != null) {
            await prefs.setString('userId', user['_id']);
          }
        }

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully!')),
        );

        
        Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const ProfessionSelectionOverlay()),
);
      }else if (response.statusCode == 409) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Email already registered!')),
  );
}
 
      else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Signup failed')),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // LOGOUT
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await ChatbotPage.clearChatOnLogout();

    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
  }

  //USER DETAILS 
  Future<Map<String, dynamic>> getUserDetails() async {
  final prefs = await SharedPreferences.getInstance();
  return {
    'name': prefs.getString('user_name') ?? '',
    'email': prefs.getString('user_email') ?? '',
    'token': prefs.getString('auth_token') ?? '',
    'userId': prefs.getString('user_id') ?? '',
    'profession': prefs.getString('profession') ?? '',
  };
}

Future<void> saveProfession(BuildContext context, String profession) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final response = await _authService.postRequest(
      '/saveProfession',
      {'profession': profession},
      token: token,
    );

    if (response['success'] == true ||
        response['message']?.toString().toLowerCase().contains('saved') == true) {
      
      await prefs.setString('profession', profession);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profession saved successfully!')),
      );

      
      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Failed to save profession')),
      );
    }
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error saving profession: $e')),
    );
  }
}


}
