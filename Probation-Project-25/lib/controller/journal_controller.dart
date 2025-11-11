import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class JournalController {
  final String baseUrl = 'https://mindease-backend-cyvy.onrender.com';

  Future<String?> submitJournalEntry(String text) async {
   try {
     final prefs = await SharedPreferences.getInstance();
     final token = prefs.getString('auth_token');
     if (token == null) return 'No token found. Please log in again.';
     final url = Uri.parse('$baseUrl/journal');
     final response = await http.post(
       url,
       headers: {
         'Content-Type': 'application/json',
         'Authorization': 'Bearer $token',
        },
       body: jsonEncode({
         'content': text,
         'date': DateTime.now().toIso8601String(), 
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
       final data = jsonDecode(response.body);
       if (data['success'] == true) return 'Journal saved successfully!';
      }
      return 'Failed to submit journal.';
    } catch (e) {
     return 'Error: $e';
    }
  }
  
  Future<List<Map<String, dynamic>>> fetchJournalEntries() async {
   try {
     final prefs = await SharedPreferences.getInstance();
     final token = prefs.getString('auth_token');
     if (token == null) return [];

     final response = await http.get(
       Uri.parse('$baseUrl/journal'),
       headers: {
         'Content-Type': 'application/json',
         'Authorization': 'Bearer $token',
        },
      );

     if (response.statusCode == 200) {
       final Map<String, dynamic> data = jsonDecode(response.body);
       final List journals = data['journals'] ?? [];
       return List<Map<String, dynamic>>.from(journals);
      } else {
       return [];
      }
    } catch (e) {
     debugPrint('Error fetching journals: $e');
     return [];
    }
  }

}
