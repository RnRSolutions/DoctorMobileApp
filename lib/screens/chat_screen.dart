

import 'package:chatbot_app/pages/homepage.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'face_recognition.dart'; // Import the FaceRecognition page
import 'dart:io';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _controller = TextEditingController();
  List<Widget> _messages = []; // List to store both text and image messages
  // String deviceId = 'your_device_id'; // Replace with actual device ID
  String deviceId = 'your_device_id';


  // Function to send text messages and store them in the MySQL database
  void _sendMessage() async {
    String message = _controller.text;
    if (message.isNotEmpty) {
      setState(() {
        _messages.add(TextMessageWidget(text: 'You: $message'));
      });
      _controller.clear();

      // Save the message to the MySQL database
      try {
        int messageId = await ApiService.saveMessage(message, deviceId);
        setState(() {
          _messages.add(TextMessageWidget(text: 'Message saved with ID: $messageId'));
        });
      } catch (e) {
        setState(() {
          _messages.add(TextMessageWidget(text: 'Error saving message: $e'));
        });
      }
    }
  }


  Future<void> _openCamera() async {
    final imagePath = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FaceRecognition()),
    );

    if (imagePath != null) {
      setState(() {
        _messages.add(ImageMessageWidget(imagePath: imagePath));
      });
    }
  }

  // Future<void> _openCamera() async {
  //     final imagePath = await Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => FaceRecognition()),
  //     );
  //
  //
  //   if (imagePath != null) {
  //
  //     final imageFile = File(imagePath);
  //     try {
  //       final imageUrl = await ApiService.uploadImageToFirebase(imageFile, deviceId);
  //       if (imageUrl != null) {
  //         await ApiService.uploadImageToFirebase(imageUrl as File, deviceId);
  //         setState(() {
  //           _messages.add(ImageMessageWidget(imagePath: imageUrl));
  //         });
  //       } else {
  //         setState(() {
  //           _messages.add(TextMessageWidget(text: 'Failed to upload image.'));
  //         });
  //       }
  //     } catch (e) {
  //       setState(() {
  //         _messages.add(TextMessageWidget(text: 'Error: $e'));
  //       });
  //     }
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Doctor'),
        backgroundColor: Colors.teal,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                // Add functionality or navigation
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.green[900],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Icon(
                  Icons.assistant_sharp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.red[900],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Icon(
                  Icons.videocam,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index];
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Enter your message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.camera),
                  onPressed: _openCamera, // Open camera to take a picture
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage, // Send text message
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Text message widget
class TextMessageWidget extends StatelessWidget {
  final String text;

  TextMessageWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text),
    );
  }
}

// Image message widget
class ImageMessageWidget extends StatelessWidget {
  final String imagePath;

  ImageMessageWidget({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Image.file(
        File(imagePath),
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      ),
    );
  }
}
