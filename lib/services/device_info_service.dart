import 'dart:io' show Platform;
import 'mobile_device_info_service.dart';
import 'web_device_info_service.dart';

abstract class DeviceInfoService {
  Future<Map<String, String>> getDeviceInfo();
}

DeviceInfoService getDeviceInfoService() {
  if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
    return MobileDeviceInfoService();
  } else {
    return WebDeviceInfoService();
  }
}



