// Import the RegistrationScreen

import 'package:chatbot_app/pages/RegisterScreen.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'JoinWithCode.dart';

class ChatScreen extends StatefulWidget {
  // const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  String baseUrl = "http://192.168.1.9:8000/api/chat/"; // PHP API URL for sending messages
  // final String appId = "YOUR_AGORA_APP_ID"; // Replace with your Agora App ID
  // final String channelName = "test";
  // final String token = "YOUR_AGORA_TOKEN"; // Replace with your Agora Token
  // late RtcEngine _engine;

  // List to store chat messages
  List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    _initializeAgora();
  }

  // Function to initialize Agora SDK
  Future<void> _initializeAgora() async {
    // _engine = createAgoraRtcEngine();
    // await _engine.initialize(RtcEngineContext(appId: appId));
  }

  // Function to send message to the server
  Future<void> _sendMessageToServer(String message) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: jsonEncode({'message': message}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        print('Message sent successfully');
      } else {
        print('Failed to send message');
      }
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  // Function to simulate sending message locally and to the server
  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      final message = _messageController.text;

      setState(() {
        _messages.add(message);
      });

      _sendMessageToServer(message); // Send message to the server

      _messageController.clear(); // Clear the input after sending
    }
  }

  // Function to start video call
  void _startVideoCall() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JoinWithCode(
          // channelName: channelName,
          // token: token,
        ),
      ),
    );
  }

  Widget _buildMessage(String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Arrow icon in white
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RegisterScreen()), // Navigate to RegistrationScreen
            );
          },
        ),
        title: const Text(
          'Chat With Doctor',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(231, 23, 11, 104),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: const BoxDecoration(
              shape: BoxShape.circle, // Circular shape for the video call icon
              color: Colors.white,
            ),
            child: IconButton(
              icon: const Icon(Icons.videocam, color: Color.fromARGB(231, 23, 11, 104)), // Video call icon inside circle
              onPressed: _startVideoCall,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30), // Oval shape for the text field
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.green), // Send icon green
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // _engine.leaveChannel();
    // _engine.release();
    super.dispose();
  }
}



