// // ImageRecognition.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:chatbot_app/pages/ChatScreen.dart';

// class ImageRecognitionScreen extends StatefulWidget {
//   const ImageRecognitionScreen({Key? key}) : super(key: key);

//   @override
//   _ImageRecognitionScreenState createState() => _ImageRecognitionScreenState();
// }

// class _ImageRecognitionScreenState extends State<ImageRecognitionScreen> {
//   final ImagePicker _picker = ImagePicker();
//   File? _capturedImage;
//   String? _selectedRelationship;

//   final List<String> _relationshipOptions = [
//     'Parent',
//     'Child',
//     'Spouse',
//     'Sibling',
//     'Friend',
//     'Caregiver',
//     'Other'
//   ];

//   Future<void> _takePhoto() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    
//     if (pickedFile != null && mounted) {
//       setState(() {
//         _capturedImage = File(pickedFile.path);
//       });
//     }
//   }

//   void _proceedToChat() {
//     if (_capturedImage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please take a photo first')),
//       );
//       return;
//     }

//     if (_selectedRelationship == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select a relationship')),
//       );
//       return;
//     }

//     Get.off(() => ChatScreen(
//       greetingMessage: "Welcome back!",
//       relationship: _selectedRelationship!,
//     ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Complete Registration"),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             Text(
//               "Please take a photo for recognition",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
            
//             // Photo capture area
//             GestureDetector(
//               onTap: _takePhoto,
//               child: Container(
//                 height: 200,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: _capturedImage == null
//                     ? Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.camera_alt, size: 50, color: Colors.grey),
//                           Text("Tap to take photo"),
//                         ],
//                       )
//                     : Image.file(_capturedImage!, fit: BoxFit.cover),
//               ),
//             ),
//             SizedBox(height: 20),
            
//             // Relationship selection
//             Text(
//               "Select Relationship:",
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 10),
//             Wrap(
//               spacing: 8,
//               children: _relationshipOptions.map((option) {
//                 return ChoiceChip(
//                   label: Text(option),
//                   selected: _selectedRelationship == option,
//                   onSelected: (selected) {
//                     setState(() {
//                       _selectedRelationship = selected ? option : null;
//                     });
//                   },
//                 );
//               }).toList(),
//             ),
//             SizedBox(height: 30),
            
//             // Proceed button
//             ElevatedButton(
//               onPressed: _proceedToChat,
//               child: Text("Continue to Chat"),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: Size(double.infinity, 50),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }