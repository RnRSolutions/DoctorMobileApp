import 'device_info_service.dart';

class WebDeviceInfoService extends DeviceInfoService {
  @override
  Future<Map<String, String>> getDeviceInfo() async {
    return {
      'manufacturer': 'Web',
      'model': 'Browser',
      'version': 'N/A'
    };
  }
}
