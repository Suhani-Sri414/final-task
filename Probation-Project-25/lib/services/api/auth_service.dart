import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'https://mindease-backend-cyvy.onrender.com';

  Future<http.Response> login(String email, String password) async {
   final url = Uri.parse('$baseUrl/login');
   return await http.post(
     url,
     headers: {'Content-Type': 'application/json'},
     body: jsonEncode({
       "email": email,
       "password": password,
      }),
    );
  }
  
  Future<http.Response> signup(String name, String email, String password) async {
   final url = Uri.parse('$baseUrl/signup');
   return await http.post(
     url,
     headers: {'Content-Type': 'application/json'},
     body: jsonEncode({
       "name": name,
       "email": email,
       "password": password,
      }),
    );
  }
  
  Future<Map<String, dynamic>> putRequest(
    String endpoint,Map<String, dynamic> data, {
      String? token,
    }
  ) async {
    try {
     final url = Uri.parse('$baseUrl$endpoint');
     final headers = {
       'Content-Type': 'application/json',
       if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };
      debugPrint(' PUT Request → $url');
      debugPrint(' Request Body → $data');
      debugPrint(' Token Sent → ${token != null && token.isNotEmpty ? token.substring(0, 20) + "..." : "No token"}');

     final response = await http.put(
       url,
       headers: headers,
       body: jsonEncode(data),
      );

     debugPrint('Response (${response.statusCode}) → ${response.body}');

     Map<String, dynamic>? decoded;
     try {
       decoded = jsonDecode(response.body);
      } catch (_) {
       decoded = {'message': response.body};
      }

     if (response.statusCode == 200) {
       return {
         'success': true,
         'data': decoded,
        };
      } else {
       return {
         'success': false,
         'message': decoded?['message'] ?? decoded?['error'] ?? 'Failed with status ${response.statusCode}',
        };
      }
    } catch (e) {
     debugPrint(' PUT Request Error: $e');
     return {
       'success': false,
       'message': 'Error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> postRequest(
    String endpoint,
    Map<String, dynamic> data, {
    String? token,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      debugPrint('POST $endpoint → ${response.statusCode}');
      debugPrint('Response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'message': 'Request failed with status: ${response.statusCode}',
          'body': response.body,
        };
      }
    } catch (e) {
      debugPrint('Error in postRequest($endpoint): $e');
      return {'success': false, 'message': 'Exception: $e'};
    }
  }
}
