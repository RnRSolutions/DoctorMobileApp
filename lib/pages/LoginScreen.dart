

import 'package:chatbot_app/pages/RegisterScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'JoinWithCode.dart';

class LoginPage extends StatefulWidget {
  // const LoginPage({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<LoginPage> {
  File? _image;
  final picker = ImagePicker();

  Future<void> _capturePhoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Upload the image to Firebase Storage
      await _uploadImageToFirebase(_image!);

      // Navigate to the ChatScreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  JoinWithCode()),
      );
    }
  }

  Future<void> _uploadImageToFirebase(File image) async {
    try {
      // Create a unique file name for the image
      String fileName = path.basename(image.path);

      // Create a reference to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child('uploads/$fileName');

      // Upload the file to Firebase
      await storageRef.putFile(image);

      // Get the download URL
      String downloadURL = await storageRef.getDownloadURL();
      print('File uploaded at: $downloadURL');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      // title: Text('Capture Photo and Upload'),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 90), // Space from top
          const Text(
            'Hello there!',
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 10), // Space between "Hello there!" and "Welcome"
          const Text(
            'Welcome',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 10), // Space between "Welcome" and "Sign in to continue with your photo"
          const Text(
            'Sign in to continue with your photo',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40), // Space after text
          ElevatedButton(
            onPressed: _capturePhoto,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(231, 23, 11, 104), // Dark blue color
            ),
            child: const Text(
              'Capture Photo',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          _image != null
              ? Image.file(_image!, height: 200, width: 200)
              : const Text('No image captured yet.'),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              // Navigate to the RegisterScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen()),
              );
            },
            child: const Text(
              "Don't have an account? Register",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    ),
  );
}

}




