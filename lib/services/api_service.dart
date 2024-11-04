
//
// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
//
// class ApiService {
//   static const String _baseUrl = 'http://192.168.1.3:8000';
//   static const String api= 'http://192.168.1.3:8000/api/ai/upload_image/';
//   // Save message to the database
//   static Future<int> saveMessage(String message, String deviceId) async {
//     final response = await http.post(
//       Uri.parse('$_baseUrl/api/messages/patient/'),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'patient_message': message,
//         'device_id': deviceId,
//       }),
//     );
//
//     print('Request body: ${jsonEncode({'patient_message': message, 'device_id': deviceId})}');
//     print('Response status: ${response.statusCode}');
//     print('Response body: ${response.body}');
//
//     if (response.statusCode == 201) {
//       final data = jsonDecode(response.body);
//       return data['id'] as int;
//     } else {
//       throw Exception('Failed to save message: ${response.body}');
//     }
//   }
//
//   // static Future<int> saveImage(String image, String deviceId) async {
//   //   final response = await http.post(
//   //     Uri.parse('$api/api/messages/patient/'),
//   //     headers: {
//   //       'Content-Type': 'application/json',
//   //     },
//   //     body: jsonEncode({
//   //       'patient_message': image,
//   //       'device_id': deviceId,
//   //     }),
//   //   );
//   //
//   //   print('Request body: ${jsonEncode({'patient_message': image, 'device_id': deviceId})}');
//   //   print('Response status: ${response.statusCode}');
//   //   print('Response body: ${response.body}');
//   //
//   //   if (response.statusCode == 201) {
//   //     final data = jsonDecode(response.body);
//   //     return data['id'] as int;
//   //   } else {
//   //     throw Exception('Failed to save message: ${response.body}');
//   //   }
//   // }
//
//
//   // Function to upload an image to Firebase Storage
//   static Future<bool> uploadImageToFirebase(File imageFile, String deviceId) async {
//     final url = Uri.parse('$api/api/ai/upload_image/');
//     var request = http.MultipartRequest('POST', url);
//
//     request.fields['device_id'] = deviceId;
//     request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
//
//     try {
//       final response = await request.send();
//       if (response.statusCode == 200) {
//         print("Image uploaded successfully!");
//         return true;
//       } else {
//         print('Failed to upload image: ${response.statusCode}');
//         return false;
//       }
//     } catch (e) {
//       print('Error uploading image: $e');
//       return false;
//     }
//   }
//
//
//
//   // Get reply from the doctor (mocked delay for demonstration)
//   static Future<String?> getReply(int messageId) async {
//     // Simulate a delay of 15 seconds
//     await Future.delayed(Duration(seconds: 15));
//
//     final response = await http.get(
//       Uri.parse('$_baseUrl/api/messages/patient/get/$messageId/'),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//     );
//
//     print('Response status: ${response.statusCode}');
//     print('Response body: ${response.body}');
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data['doctor_response'] as String?;
//     } else {
//       throw Exception('Failed to get reply');
//     }
//   }
// }


import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://192.168.1.9:8000';
  static const String _uploadImageUrl = 'http://192.168.1.9:8000/api/ai/upload_image/';

  // Save message to the database
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
      throw Exception('Failed to save message: ${response.body}');
    }
  }

  // Upload an image to Firebase Storage
  static Future<String?> uploadImageToFirebase(File imageFile, String deviceId) async {
    final uri = Uri.parse(_uploadImageUrl);
    var request = http.MultipartRequest('POST', uri);

    // Add deviceId as a field in the form
    request.fields['device_id'] = deviceId;
    // Add image file
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final responseJson = jsonDecode(responseData);
        final imageUrl = responseJson['image_url'] as String?;
        print("Image uploaded successfully!");
        return imageUrl;
      } else {
        print('Failed to upload image: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Save a message with image URL to the database
  // static Future<int> saveMessageWithImage(String imageUrl, String deviceId) async {
  //   final response = await http.post(
  //     Uri.parse('$_baseUrl/api/messages/patient/'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode({
  //       'patient_message': imageUrl,
  //       'device_id': deviceId,
  //     }),
  //   );
  //
  //   print('Request body: ${jsonEncode({'patient_message': imageUrl, 'device_id': deviceId})}');
  //   print('Response status: ${response.statusCode}');
  //   print('Response body: ${response.body}');
  //
  //   if (response.statusCode == 201) {
  //     final data = jsonDecode(response.body);
  //     return data['id'] as int;
  //   } else {
  //     throw Exception('Failed to save message: ${response.body}');
  //   }
  // }

  // Get reply from the doctor (mocked delay for demonstration)
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
