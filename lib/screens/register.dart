
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _ageController = TextEditingController();
  File? _faceImage;
  final picker = ImagePicker();

  // API URLs
  final String apiUrlMySQL = "http://192.168.1.3:8000/api/signup"; // MySQL API URL
  final String apiUrlFirebase = "http://192.168.1.3:8000/api/ai/upload_image/"; // Firebase API URL

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _faceImage = File(pickedFile.path);
      });
    }
  }

  Future<void> registerUser() async {
    String username = _usernameController.text;
    String age = _ageController.text;

    if (username.isEmpty || age.isEmpty || _faceImage == null) {
      print("Please fill all fields and capture a face image.");
      return;
    }

    String? imageUrl = await uploadImageToFirebase(_faceImage!);
    if (imageUrl != null) {
      await registerInMySQL(username, age, imageUrl);
    }
  }

  Future<String?> uploadImageToFirebase(File imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrlFirebase));
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await http.Response.fromStream(response);
        var jsonData = json.decode(responseBody.body);
        return jsonData['imageUrl']; // Assuming the API returns the image URL
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error during image upload: $e');
      return null;
    }
  }

  Future<void> registerInMySQL(String username, String age, String imageUrl) async {
    try {
      var response = await http.post(
        Uri.parse(apiUrlMySQL),
        body: jsonEncode({
          'username': username,
          'age': age,
          'image_url': imageUrl,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        print('User registered successfully');
      } else {
        print('Failed to register user. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error during registration: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            _faceImage == null
                ? Text('No face image selected.')
                : Image.file(_faceImage!, height: 100),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: pickImage,
              child: Text('Capture Face Image'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // To place buttons left and right
              children: [
                ElevatedButton(
                  onPressed: registerUser,
                  child: Text('Register'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the login page (implement login page navigation here)
                  },
                  child: Text('Login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

