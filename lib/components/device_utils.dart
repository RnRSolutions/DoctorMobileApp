import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
// import 'package:http/http.dart' as http;
// import 'package:chatbot_app/pages/const.dart';  // Import the constants

Future<String?> getDeviceId() async {
  try {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // Unique ID for Android
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor; // Unique ID for iOS
    }
  } catch (e) {
    print("Error fetching device ID: $e");
  }
  return null; // Return null if unable to fetch 
}
