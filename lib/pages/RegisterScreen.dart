

import 'package:chatbot_app/pages/LoginScreen.dart';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

class RegisterScreen extends StatefulWidget {
  // const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _familyNameController = TextEditingController();
  File? _image1, _image2, _image3;
  final picker = ImagePicker();
  String? _deviceId;
  
  get fileName => null;

  @override
  void initState() {
    super.initState();
    _getDeviceId();
  }

  // Retrieve the device ID for Android and iOS
  Future<void> _getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        setState(() {
          _deviceId = androidInfo.id; // Correct way to access androidId
        });
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        setState(() {
          _deviceId = iosInfo.identifierForVendor; // Correct way to access iOS device ID
        });
      }
      print('Device ID: $_deviceId'); // Debugging
    } catch (e) {
      print('Error retrieving device ID: $e');
    }
  }

  // Capture photos from the camera
  Future<void> _capturePhotos() async {
    final pickedFile1 = await picker.pickImage(source: ImageSource.camera);
    final pickedFile2 = await picker.pickImage(source: ImageSource.camera);
    final pickedFile3 = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile1 != null) _image1 = File(pickedFile1.path);
      if (pickedFile2 != null) _image2 = File(pickedFile2.path);
      if (pickedFile3 != null) _image3 = File(pickedFile3.path);
    });

    print(
        'Image 1: ${_image1?.path}, Image 2: ${_image2?.path}, Image 3: ${_image3?.path}');
  }

  // Upload images to Firebase Storage
  Future<void> _uploadImagesToFirebase() async {
    List<File?> images = [_image1, _image2, _image3];

    for (var image in images) {
      if (image != null) {
        try {
          String fileName = path.basename(image.path);
          final storageRef =
              FirebaseStorage.instance.ref().child('uploads/$fileName');
          await storageRef.putFile(image);
          print('Uploaded: $fileName'); // Debugging
        } catch (e) {
          print('Error uploading image: $e');
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error uploading image: $fileName')));
        }
      } else {
        print('Image is null');
      }
    }
  }



  // Sign up and send data (including device ID) to the server
  Future<void> _signUp() async {
    if (_validateInputs()) {
      try {
        var request = http.MultipartRequest(
            'POST', Uri.parse('http://192.168.1.12:8000/api/signup/'));
            // 'POST', Uri.parse('https://rnrobots.services/api/signup/'));

        

        request.fields['name'] = _nameController.text.trim();
        request.fields['age'] = _ageController.text.trim();
        request.fields['family_name'] = _familyNameController.text.trim();
        request.fields['device_id'] = _deviceId ?? "unknown"; // Save device ID

        // Attach images to the request
        List<File?> images = [_image1, _image2, _image3];
        for (var image in images) {
          if (image != null) {

            // Determine the MIME type of the image
            String mimeType = getMimeType(image.path) ?? 'application/octet-stream';
            var mimeTypeParts = mimeType.split('/');
        
            request.files
                .add(await http.MultipartFile.fromPath(
                  "photos", 
                  image.path,
                  contentType: MediaType(mimeTypeParts[0], mimeTypeParts[1])
                  ));
          }
        }

        print("Sending request...");
        await request.send().then((response){
          response.stream.transform(utf8.decoder).listen((responseVal) async {
            var jsonRes = json.decode(responseVal);
            print('JSON Response: $jsonRes');
            print('Response status: $response.statusCode');
            print(response);
            
            
            if (response.statusCode == 200) {
              ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Registration successful!')));
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Registration failed. Please try again.')));
            }
          });
        });

        
      } catch (e) {
        print('Error in sign up: $e');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('An error occurred during registration.')));
      }
    }
  }

  String getMimeType(String filePath) {
  if (filePath.endsWith('.jpg') || filePath.endsWith('.jpeg')) {
    return 'image/jpeg';
  } else if (filePath.endsWith('.png')) {
    return 'image/png';
  } else if (filePath.endsWith('.gif')) {
    return 'image/gif';
  } else if (filePath.endsWith('.bmp')) {
    return 'image/bmp';
  } else if (filePath.endsWith('.webp')) {
    return 'image/webp';
  }
  return 'application/octet-stream'; // Default if unknown
}

  // Validate user inputs
  bool _validateInputs() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your name.')));
      return false;
    }
    if (_familyNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your family name.')));
      return false;
    }
    if (_ageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your age.')));
      return false;
    }
    final age = int.tryParse(_ageController.text);
    if (age == null || age <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid age.')));
      return false;
    }
    if (_image1 == null || _image2 == null || _image3 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please capture all three photos.')));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                const Text(
                  'Register',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                Container(
                  width: 320, // Set your desired width here
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Enter Name',
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 320, // Set your desired width here
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      controller: _ageController,
                      decoration: InputDecoration(
                        labelText: 'Enter Age',
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 320, // Set your desired width here
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      controller: _familyNameController,
                      decoration: InputDecoration(
                        labelText: 'Enter Family Name',
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _capturePhotos,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(
                        231, 23, 11, 104), // Dark blue color
                    fixedSize: const Size(180, 40), // Button size
                  ),
                  child: const Text('Capture 3 Photos'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(
                        231, 23, 11, 104), // Dark blue color
                    fixedSize: const Size(180, 40), // Button size
                  ),
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}





