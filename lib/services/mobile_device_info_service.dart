import 'package:device_info_plus/device_info_plus.dart';
import 'device_info_service.dart';


class MobileDeviceInfoService extends DeviceInfoService {
  @override
  Future<Map<String, String>> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    var androidInfo = await deviceInfoPlugin.androidInfo;
    return {
      'manufacturer': androidInfo.manufacturer ?? 'Unknown',
      'model': androidInfo.model ?? 'Unknown',
      'id': androidInfo.id ?? 'Unknown',
      'version': 'Android API ${androidInfo.version.sdkInt ?? 'Unknown'}',

    };

  }
}
