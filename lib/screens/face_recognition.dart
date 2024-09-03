
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'gallery_screen.dart';

class FaceRecognition extends StatefulWidget {
  @override
  _FaceRecognitionState createState() => _FaceRecognitionState();
}

class _FaceRecognitionState extends State<FaceRecognition> {
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  late List<CameraDescription> cameras;
  late CameraDescription frontCamera;
  late CameraDescription backCamera;
  bool isUsingFrontCamera = true;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    frontCamera = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);
    backCamera = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.back);

    _cameraController = CameraController(
      isUsingFrontCamera ? frontCamera : backCamera,
      ResolutionPreset.medium,
    );

    // Request permissions
    if (await Permission.camera.isGranted && await Permission.microphone.isGranted) {
      _initializeControllerFuture = _cameraController!.initialize().then((_) {
        if (!mounted) return;
        setState(() {
          _isCameraInitialized = true;
        });
      }).catchError((e) {
        print('Error initializing camera: $e');
      });
    } else {
      await _requestPermissions();
    }
  }

  Future<void> _requestPermissions() async {
    var cameraStatus = await Permission.camera.request();
    var microphoneStatus = await Permission.microphone.request();

    if (cameraStatus.isGranted && microphoneStatus.isGranted) {
      _initializeCamera();
    } else {
      _showPermissionDialog();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permissions Required'),
        content: Text('This app needs camera and microphone access to function properly.'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _takePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      await _initializeControllerFuture;
      final XFile image = await _cameraController!.takePicture();

      // Get the directory to save the photo
      final directory = await getApplicationDocumentsDirectory();
      final String photosDirPath = '${directory.path}/photos';
      final Directory photosDir = Directory(photosDirPath);

      if (!await photosDir.exists()) {
        await photosDir.create(recursive: true);
      }

      final String path = '$photosDirPath/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final File newImage = await File(image.path).copy(path);

      print('Photo saved to: $path');

      // Navigate to the gallery screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GalleryScreen()),
      );
    } catch (e) {
      print('Error taking photo: $e');
    }
  }

  void _switchCamera() async {
    if (_cameraController != null) {
      await _cameraController!.dispose();
    }
    setState(() {
      isUsingFrontCamera = !isUsingFrontCamera;
      _isCameraInitialized = false;
    });
    await _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Recognition'),
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        backgroundColor: Color(0xFF4DB6AC),
        actions: [
          IconButton(
            icon: Icon(Icons.switch_camera),
            onPressed: _switchCamera,
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (_isCameraInitialized) {
            if (_cameraController != null && _cameraController!.value.isInitialized) {
              return Column(
                children: [
                  Expanded(
                    child: CameraPreview(_cameraController!),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: _takePhoto,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[200], // Set the button's background color to green
                      ),
                      child: Text('Take Picture'),
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: Text('Camera not initialized.'));
            }
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}












