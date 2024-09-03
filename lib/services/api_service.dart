

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class ApiService {
  static const String _baseUrl = 'http://192.168.1.6:8000';

  static Future<int> saveMessage(String message, String deviceId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/messages/patient/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'patient_message': message,
        'device_id': deviceId,
      }),
    );

    print('Request body: ${jsonEncode({'patient_message': message, 'device_id': deviceId})}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['id'] as int;
    } else {
      throw Exception('Failed to save message');
    }
  }

  static Future<String?> getReply(int messageId) async {
    // Simulate a delay of 15 seconds
    await Future.delayed(Duration(seconds: 15));

    final response = await http.get(
      Uri.parse('$_baseUrl/api/messages/patient/get/$messageId/'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['doctor_response'] as String?;
    } else {
      throw Exception('Failed to get reply');
    }
  }
}






