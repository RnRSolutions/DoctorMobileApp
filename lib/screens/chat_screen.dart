




import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'new_page.dart'; // Import the MyForm page
import 'package:device_info_plus/device_info_plus.dart';
import 'service_page.dart';
import 'face_recognition.dart'; // Import the FaceRecognition page
import 'create_channel_page.dart'; // Updated import

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _controller = TextEditingController();
  List<String> _messages = [];
  String? _deviceId;

  @override
  void initState() {
    super.initState();
    _getDeviceId();
  }

  Future<void> _getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    var androidInfo = await deviceInfo.androidInfo;
    setState(() {
      _deviceId = androidInfo.androidId; // Use 'androidId' as 'device_id'
    });
  }

  void _sendMessage() async {
    if (_deviceId == null) {
      // Device ID is not ready yet
      setState(() {
        _messages.add('Failed to send message: Device ID not available');
      });
      return;
    }

    String message = _controller.text;
    setState(() {
      _messages.add('You: $message');
    });

    try {
      int messageId = await ApiService.saveMessage(message, _deviceId!);
      setState(() {
        _messages.add('Waiting for doctor\'s reply...');
      });

      String? reply = await ApiService.getReply(messageId);

      setState(() {
        _messages.removeLast(); // Remove the waiting message
        if (reply != null) {
          _messages.add('Doctor: $reply');
        } else {
          _messages.add('Failed to get a reply from the doctor');
        }
      });
    } catch (e) {
      setState(() {
        _messages.add('Failed to send message');
      });
    }
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Doctor'),
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        backgroundColor: Color(0xFF4DB6AC),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16.0), // Add some margin if needed
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyForm()),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.blue[900],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Icon(
                  Icons.smartphone,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 16.0), // Add some margin if needed
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ServicePage()),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.green[900],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Icon(
                  Icons.assistant_sharp ,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 16.0), // Add some margin if needed
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FaceRecognition()),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.yellow[900],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Icon(
                  Icons.face,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          //new button
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateChannelPage()),
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
                bool isDoctorMessage = _messages[index].startsWith('Doctor:');
                return Align(
                  alignment: isDoctorMessage ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: isDoctorMessage ? Colors.green[100] : Colors.blue[100],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      _messages[index],
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                );
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
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



