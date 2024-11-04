// import 'package:chatbot_app/pages/joinWithCode.dart';
// import 'package:chatbot_app/pages/new_meeting.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Video Conference"),
//         centerTitle: true,
//       ),
//       body: Column(children: [
//         Padding(
//           padding: const EdgeInsets.fromLTRB(20, 40, 0, 0),
//           child: ElevatedButton.icon(
//             onPressed: () {
//               Get.to(NewMeeting());
//             },
//             icon: Icon(Icons.add),
//             label: Text("New Meeting"),
//             style: ElevatedButton.styleFrom(
//               fixedSize: Size(350, 30), backgroundColor: Colors.indigo,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(25)),
//             ),
//           ),
//         ),
//         Divider(
//           thickness: 1,
//           height: 40,
//           indent: 40,
//           endIndent: 20,
//         ),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
//           child: OutlinedButton.icon(
//             onPressed: () {
//               Get.to(JoinWithCode());
//             },
//             icon: Icon(Icons.margin),
//             label: Text("Join with a code"),
//             style: OutlinedButton.styleFrom(
//               foregroundColor: Colors.indigo, side: BorderSide(color: Colors.indigo),
//               fixedSize: Size(350, 30),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(25)),
//             ),
//           ),
//         ),
//         SizedBox(height: 150),
//         Image.network(
//             "https://user-images.githubusercontent.com/67534990/127524449-fa11a8eb-473a-4443-962a-07a3e41c71c0.png")
//       ]),
//     );
//   }
// }
//
//
//
//
//
//
//
//
//
//


import 'package:chatbot_app/pages/joinWithCode.dart';
import 'package:chatbot_app/pages/new_meeting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Conference"),
        centerTitle: true,
        backgroundColor: Colors.indigo, // You can adjust this as needed
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 0, 0),
          child: ElevatedButton.icon(
            onPressed: () {
              Get.to(NewMeeting());
            },
            icon: Icon(Icons.add, color: Colors.white), // Set icon color to white
            label: Text(
              "New Meeting",
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
            style: ElevatedButton.styleFrom(
              fixedSize: Size(350, 30),
              backgroundColor: Colors.indigo, // Button background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
        Divider(
          thickness: 1,
          height: 40,
          indent: 40,
          endIndent: 20,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: OutlinedButton.icon(
            onPressed: () {
              Get.to(JoinWithCode());
            },
            icon: Icon(Icons.margin, color: Colors.indigo),
            label: Text(
              "Join with a code",
              style: TextStyle(color: Colors.indigo), // Keep text indigo
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.indigo, // Text color
              side: BorderSide(color: Colors.indigo), // Border color
              fixedSize: Size(350, 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
        SizedBox(height: 150),
        // Adding a container with a matching background color for the image area
        Container(
          color: Colors.grey[100], // Background color to match image tones
          padding: EdgeInsets.all(20),
          child: Image.network(
            "https://user-images.githubusercontent.com/67534990/127524449-fa11a8eb-473a-4443-962a-07a3e41c71c0.png",
            fit: BoxFit.cover, // Ensure the image fits well
          ),
        ),
      ]),
    );
  }
}
