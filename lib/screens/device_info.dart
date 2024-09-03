


import 'package:flutter/material.dart';
import '../services/device_info_service.dart';


class DeviceInfo extends StatefulWidget {
  const DeviceInfo({Key? key}) : super(key: key);

  @override
  _DeviceInfoState createState() => _DeviceInfoState();
}

class _DeviceInfoState extends State<DeviceInfo> {
  late Future<Map<String, String>> _deviceInfo;

  @override
  void initState() {
    super.initState();
    _deviceInfo = getDeviceInfoService().getDeviceInfo();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Device Info'),
          backgroundColor: Color(0xFF4DB6AC),
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),
        ),
        body: FutureBuilder<Map<String, String>>(
          future: _deviceInfo,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                var data = snapshot.data!;
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Manufacturer: ${data['manufacturer']}'),
                      Text('Model: ${data['model']}'),
                      Text('Id: ${data['id']}'),
                      Text('Version: ${data['version']}'),
                    ],
                  ),
                );
              } else {
                return Center(child: Text('Failed to get device info'));
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}





