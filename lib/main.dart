// // import 'package:flutter/material.dart';
// // import 'screens/chat_screen.dart';
// // import 'screens/new_page.dart';
// //
// //
// // void main() {
// //   runApp(MyApp());
// // }
// //
// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'ChatBot',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //       ),
// //       home: ChatScreen(),
// //     );
// //   }
// // }
// //

import 'package:chatbot_app/pages/homepage.dart';
import 'package:chatbot_app/screens/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'screens/chat_screen.dart';
import 'screens/new_page.dart';
import 'screens/device_info.dart';



// Import Firebase Core

void main() {
  runApp(MyApp());
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//      // Add this if using CLI
//   );
//   runApp(MyApp());
// }


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ChatBot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:HomePage(),
      routes: {
        // '/newPage': (context) => MyForm(),
        // '/deviceInfo': (context) => DeviceInfo(),

      },
    );
  }
}


// import 'package:chatbot_app/pages/homepage.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';


// void main() {
//   runApp(GetMaterialApp(home: HomePage()));
// }
