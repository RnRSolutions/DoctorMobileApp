

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'view_photo_screen.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late Future<List<File>> _photos;

  @override
  void initState() {
    super.initState();
    _photos = _loadPhotos();
  }

  Future<List<File>> _loadPhotos() async {
    final directory = await getApplicationDocumentsDirectory();
    final photosDir = Directory('${directory.path}/photos');
    final List<File> photoFiles = [];

    if (await photosDir.exists()) {
      final List<FileSystemEntity> files = photosDir.listSync();
      for (var file in files) {
        if (file is File) {
          photoFiles.add(file);
        }
      }
    }

    return photoFiles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        backgroundColor: Color(0xFF4DB6AC),
      ),
      body: FutureBuilder<List<File>>(
        future: _photos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No photos found.'));
          } else {
            final photoFiles = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: photoFiles.length,
              itemBuilder: (context, index) {
                final file = photoFiles[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewPhotoScreen(
                          photoPath: file.path,
                          uploadUrl: 'http://192.168.1.9:8000/api/ai/upload_image/', // Your API URL


                        ),
                      ),
                    );


                  },
                  child: Image.file(
                    file,
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}


