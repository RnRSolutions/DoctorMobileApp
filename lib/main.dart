// import 'package:flutter/material.dart';
// import 'screens/chat_screen.dart';
// import 'screens/new_page.dart';
//
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ChatBot',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: ChatScreen(),
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';
import 'screens/new_page.dart';
import 'screens/device_info.dart';

import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core

void main() {
  runApp(MyApp());
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatBot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatScreen(),
      routes: {
        '/newPage': (context) => MyForm(),
        '/deviceInfo': (context) => DeviceInfo(),

      },
    );
  }
}



