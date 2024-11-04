
import 'package:chatbot_app/video_call.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:uuid/uuid.dart';

class NewMeeting extends StatefulWidget {
  NewMeeting({Key? key}) : super(key: key);

  @override
  _NewMeetingState createState() => _NewMeetingState();
}

class _NewMeetingState extends State<NewMeeting> {
  String _meetingCode = "abcdfgqw";

  @override
  void initState() {
    var uuid = Uuid();
    _meetingCode = uuid.v1().substring(0, 8); // Generate a unique meeting code
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      Colors.lightBlue[100], // Set background color to light blue
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                child: Icon(Icons.arrow_back_ios_new_sharp, size: 35),
                onTap: Get.back,
              ),
            ),
            SizedBox(height: 50),
            Image.network(
              "https://user-images.githubusercontent.com/67534990/127776392-8ef4de2d-2fd8-4b5a-b98b-ea343b19c03e.png",
              fit: BoxFit.cover,
              height: 100,
            ),
            SizedBox(height: 20),
            Text(
              "Enter meeting code below",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
              child: Card(
                color: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: ListTile(
                  leading: Icon(Icons.link),
                  title: SelectableText(
                    _meetingCode,
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  trailing: Icon(Icons.copy),
                ),
              ),
            ),
            Divider(thickness: 1, height: 40, indent: 20, endIndent: 20),
            ElevatedButton.icon(
              onPressed: () {
                Share.share("Meeting Code: $_meetingCode");
              },
              icon: Icon(Icons.arrow_drop_down),
              label: Text(
                "Share invite",
                style:
                TextStyle(color: Colors.white), // Set text color to white
              ),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(350, 30),
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () {
                Get.to(VideoCall(channelName: _meetingCode.trim()));
                // Get.to(VideoCall());
              },
              icon: Icon(Icons.video_call),
              label: Text("Start call"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.indigo,
                side: BorderSide(color: Colors.indigo),
                fixedSize: Size(350, 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


