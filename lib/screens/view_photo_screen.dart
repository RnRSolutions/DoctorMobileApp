
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:photo_view/photo_view.dart';
import 'package:http/http.dart' as http;



class ViewPhotoScreen extends StatelessWidget {
  final String photoPath;
  final String uploadUrl;

  ViewPhotoScreen({required this.photoPath, required this.uploadUrl});




  Future<void> _uploadPhoto() async {
    try {
      File file = File(photoPath);
      String fileName = file.uri.pathSegments.last;

      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
      });
      request.files.add(await http.MultipartFile.fromPath('file', file.path, filename: fileName));

      var response = await request.send();

      final responseBody = await response.stream.bytesToString();

      print('Status Code: ${response.statusCode}');
      print('Response Body: $responseBody');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('File Uploaded Successfully');
      } else {
        print('Failed to Upload File');
        print('Response Status: ${response.statusCode}');
        print('Response Reason: ${response.reasonPhrase}');
      }
    } catch (e) {

      print('Error uploading photo: e');

    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Photo'),
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        backgroundColor: Color(0xFF4DB6AC),
        actions: [
          IconButton(
            icon: Icon(Icons.cloud_upload),
            onPressed: _uploadPhoto,
          ),
        ],
      ),
      body: Center(
        child: PhotoView(
          imageProvider: FileImage(File(photoPath)),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:photo_view/photo_view.dart';
// import 'package:http/http.dart' as http;
//
// class ViewPhotoScreen extends StatefulWidget {
//   final String photoPath;
//   final String uploadUrl;
//
//   ViewPhotoScreen({required this.photoPath, required this.uploadUrl});
//
//   @override
//   _ViewPhotoScreenState createState() => _ViewPhotoScreenState();
// }
//
// class _ViewPhotoScreenState extends State<ViewPhotoScreen> {
//   bool _isUploading = false;
//
//   Future<void> _uploadPhoto() async {
//     setState(() {
//       _isUploading = true;
//     });
//
//     try {
//       File file = File(widget.photoPath);
//       String fileName = file.uri.pathSegments.last;
//
//       var request = http.MultipartRequest('POST', Uri.parse(widget.uploadUrl));
//       request.headers.addAll({
//         'Content-Type': 'multipart/form-data',
//       });
//       request.files.add(await http.MultipartFile.fromPath('file', file.path, filename: fileName));
//
//       var response = await request.send().timeout(Duration(seconds: 60)); // Set a timeout duration
//
//       final responseBody = await response.stream.bytesToString();
//
//       print('Status Code: ${response.statusCode}');
//       print('Response Body: $responseBody');
//
//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         print('File Uploaded Successfully');
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('File uploaded successfully!')));
//       } else {
//         print('Failed to Upload File');
//         print('Response Status: ${response.statusCode}');
//         print('Response Reason: ${response.reasonPhrase}');
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to upload file.')));
//       }
//     } catch (e) {
//       print('Error uploading photo: $e');
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error uploading photo: $e')));
//     } finally {
//       setState(() {
//         _isUploading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('View Photo'),
//         titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//         backgroundColor: Color(0xFF4DB6AC),
//         actions: [
//           if (!_isUploading)
//             IconButton(
//               icon: Icon(Icons.cloud_upload),
//               onPressed: _uploadPhoto,
//             ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           Center(
//             child: PhotoView(
//               imageProvider: FileImage(File(widget.photoPath)),
//             ),
//           ),
//           if (_isUploading)
//             Center(
//               child: CircularProgressIndicator(),
//             ),
//         ],
//       ),
//     );
//   }
// }




