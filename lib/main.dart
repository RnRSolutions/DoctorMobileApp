import 'package:chatbot_app/components/welcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatbot_app/patient%20screens/PatientRegisterScreen.dart';
import 'package:chatbot_app/components/RoleSelectionScreen.dart';
import 'package:chatbot_app/doctor%20screens/DoctorRegisterScreen.dart';
import 'package:chatbot_app/patient%20screens/ChatScreen.dart';
import 'package:chatbot_app/meeting_screens/video_conference.dart';
import 'package:chatbot_app/doctor%20screens/users_chat_list.dart';
import 'package:chatbot_app/components/LoginScreen.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put<RouteObserver<PageRoute>>(routeObserver);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [Get.find<RouteObserver<PageRoute>>()],
      initialRoute: '/firstScreen',
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 200),
      getPages: [
        GetPage(
          name: '/firstScreen',
          page: () => const FirstScreen(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 200),
        ),
        GetPage(
          name: '/roleSelection',
          page: () => const RoleSelectionScreen(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 200),
        ),
        GetPage(
          name: '/patientRegister',
          page: () => RegisterScreen(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 200),
        ),
        GetPage(
          name: '/doctorRegister',
          page: () => const DoctorRegisterScreen(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 200),
        ),
        GetPage(
          name: '/chat',
          page: () => ChatScreen(
            greetingMessage: "Welcome back!",
          ),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 200),
        ),
        GetPage(
          name: '/videoConference',
          page: () => const VideoConference(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 200),
        ),
        GetPage(
          name: '/usersList',
          page: () => const UsersChatList(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 200),
        ),
        GetPage(
          name: '/login',
          
          page: () => const LoginPage(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }
}
