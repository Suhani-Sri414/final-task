import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mind_ease_app/views/navbar/ai_therapist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api/auth_service.dart';

class AuthController {
  final AuthService _authService = AuthService();

  // Login 
  Future<void> login(BuildContext context, String email, String password) async {
   try {
     final response = await _authService.login(email, password);
     Map<String, dynamic> data;
     try {
       data = jsonDecode(response.body);
      } catch (e) {
       if (!context.mounted) return;
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Invalid server response: ${response.body}')),
        );
        return;
      }
     if (response.statusCode == 200 && data['user'] != null && data['accessToken'] != null) {
       final user = data['user'];
       final token = data['accessToken'];
       final prefs = await SharedPreferences.getInstance();
       await prefs.setString('auth_token', token);
       await prefs.setString('user_name', user['name'] ?? '');
       await prefs.setString('user_email', user['email'] ?? '');
       await prefs.setString('user_id', user['id'] ?? '');
       await prefs.setBool('isLoggedIn', true);
       if (!context.mounted) return;
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Welcome back, ${user['name']}!')),
        );
       Navigator.pushReplacementNamed(context, 'home');
      } 
     else {
       final errorMsg = data['message'] ??
       data['error'] ??
       'Login failed. Please check your credentials.';
       if (!context.mounted) return;
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(errorMsg)),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
     ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
     );
    }
  }

  // Signup 
  Future<void> signup(BuildContext context,String name,String email,String password,) async {
   try {
     final response = await _authService.signup(name, email, password);
     final data = jsonDecode(response.body);

     if (response.statusCode == 201 || response.statusCode == 200) {
       final prefs = await SharedPreferences.getInstance();
       await prefs.setString('userId', data['_id'] ?? '');
       await prefs.setString('name', data['name'] ?? name);
       await prefs.setString('email', data['email'] ?? email);
       await prefs.setString('phone', data['phone'] ?? '');
       await prefs.setString('gender', data['gender'] ?? '');
       await prefs.setString('age', data['age'] ?? '');
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
        Navigator.pushReplacementNamed(context, 'home');
      } 
      else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Signup failed')),
        );
      }
    } 
    catch (e) {
     if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  //  Logout 
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await ChatbotPage.clearChatOnLogout();

    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context,'login',(route) => false);

  }

  //  User Details 
  Future<Map<String, dynamic>> getUserDetails() async {
   final prefs = await SharedPreferences.getInstance();
   return {
     'name': prefs.getString('name') ?? '',
     'email': prefs.getString('email') ?? '',
     'token': prefs.getString('token') ?? '',
     'userId': prefs.getString('userId') ?? '',
    };
  }
}
