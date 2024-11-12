
import 'package:chatbot_app/video_call.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JoinWithCode extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100], // Set background color here
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                child: Icon(Icons.arrow_back_ios_new_sharp, size: 35),
                onTap: () => Get.back(),
              ),
            ),
            SizedBox(height: 50),
            Image.network(
              "https://user-images.githubusercontent.com/67534990/127776450-6c7a9470-d4e2-4780-ab10-143f5f86a26e.png",
              fit: BoxFit.cover,
              height: 100,
            ),
            SizedBox(height: 20),
            Text(
              "Enter meeting code below",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
              child: Card(
                color: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _controller,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Example: abc-efg-dhi"),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(VideoCall(channelName: _controller.text.trim()));
                // Get.to(VideoCall());
              },
              child: Text(
                "Join",
                style: TextStyle(
                    color: Colors.white), // Set the text color to white
              ),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(200, 30),
                backgroundColor: Colors.indigo,
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







// import 'package:chatbot_app/video_call.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class JoinWithCode extends StatelessWidget {
//   final TextEditingController _controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background Image
//           Positioned.fill(
//             child: Image.network(
//               "https://www.dreamstime.com/online-doctor-app-health-phone-mockup-get-consultation-mobile-stethoscope-cell-blue-background-copy-space-image209196925", // Replace with your desired image URL
//               fit: BoxFit.cover,
//             ),
//           ),
//           // Overlay to darken background image slightly
//           Container(
//             color: Colors.black.withOpacity(0.5),
//           ),
//           SafeArea(
//             child: Column(
//               children: [
//                 Align(
//                   alignment: Alignment.topLeft,
//                   child: InkWell(
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Icon(
//                         Icons.arrow_back_ios_new_sharp,
//                         size: 35,
//                         color: Colors.white, // Set the icon color to white for visibility
//                       ),
//                     ),
//                     onTap: () => Get.back(),
//                   ),
//                 ),
//                 SizedBox(height: 50),
//                 // Centered Logo/Image
//                 Image.network(
//                   "https://user-images.githubusercontent.com/67534990/127776450-6c7a9470-d4e2-4780-ab10-143f5f86a26e.png",
//                   fit: BoxFit.cover,
//                   height: 100,
//                 ),
//                 SizedBox(height: 20),
//                 // Instructional Text
//                 Text(
//                   "Enter meeting code below",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white, // Text color set to white for better contrast
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
//                   child: Card(
//                     color: Colors.grey[300],
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                     child: TextField(
//                       controller: _controller,
//                       textAlign: TextAlign.center,
//                       decoration: InputDecoration(
//                         border: InputBorder.none,
//                         hintText: "Example: abc-efg-dhi",
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 // Join Button
//                 ElevatedButton(
//                   onPressed: () {
//                     Get.to(VideoCall(channelName: _controller.text.trim()));
//                     // Get.to(VideoCall());
//                   },
//                   child: Text(
//                     "Join",
//                     style: TextStyle(color: Colors.white), // Set the text color to white
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     fixedSize: Size(200, 45),
//                     backgroundColor: Colors.indigo,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
