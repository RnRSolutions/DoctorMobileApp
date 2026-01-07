import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:chatbot_app/components/constant.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with RouteAware, WidgetsBindingObserver {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _familyNameController = TextEditingController();
  File? image1, image2, _image3;
  final picker = ImagePicker();
  String? _deviceId;
  bool _isSubmitting = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Show screen immediately, run initialization in background
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
    // Set loading to false immediately to show UI
    _isLoading = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      final routeObserver = Get.find<RouteObserver<PageRoute>>();
      routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
    } catch (e) {
      debugPrint('RouteObserver not found: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    final routeObserver = Get.find<RouteObserver<PageRoute>>();
    routeObserver.unsubscribe(this);
    _nameController.dispose();
    _ageController.dispose();
    _familyNameController.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    await _fetchDeviceId();
    final prefs = await SharedPreferences.getInstance();
    bool locallyRegistered = prefs.getBool('isRegistered') ?? false;

    // Check if we've already verified with backend in the last hour
    int? lastBackendCheck = prefs.getInt('lastBackendCheck');
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    bool shouldCheckBackend =
        lastBackendCheck == null || (currentTime - lastBackendCheck) > 3600000;

    if (!locallyRegistered && _deviceId != null && shouldCheckBackend) {
      bool backendRegistered = await _checkBackendRegistration();
      if (backendRegistered) {
        await prefs.setBool('isRegistered', true);
        await prefs.setInt('lastBackendCheck', currentTime);
        if (mounted) {
          _redirectToChatScreen();
          return;
        }
      } else {
        await prefs.setInt('lastBackendCheck', currentTime);
      }
    } else if (locallyRegistered) {
      // Already registered, skip to chat
      if (mounted) {
        _redirectToChatScreen();
        return;
      }
    }
  }

  Future<bool> _checkBackendRegistration() async {
    try {
      final response = await http.get(
        Uri.parse('https://rnrobots.services/api/check-user/$_deviceId/'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['exists'] == true;
      }
      return false;
    } catch (e) {
      debugPrint('Error checking backend registration: $e');
      return false;
    }
  }

  Future<void> _redirectToChatScreen() async {
    final prefs = await SharedPreferences.getInstance();
    String userName = prefs.getString('userName') ?? 'User';

    if (mounted) {
      Get.offNamed('/chat', arguments: {
        'greetingMessage': "Welcome back, $userName!",
        'relationship': '',
      });
    }
  }

  Future<void> _fetchDeviceId() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final deviceData = await deviceInfo.androidInfo;
      setState(() {
        _deviceId = deviceData.id;
      });
    } catch (e) {
      debugPrint('Error getting device ID: $e');
    }
  }

  Future<void> _capturePhotos() async {
    if (!_areFieldsFilled()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all details before capturing photos')),
      );
      return;
    }

    final pickedFile1 = await picker.pickImage(source: ImageSource.camera);
    final pickedFile2 = await picker.pickImage(source: ImageSource.camera);
    final pickedFile3 = await picker.pickImage(source: ImageSource.camera);

    if (mounted) {
      setState(() {
        if (pickedFile1 != null) image1 = File(pickedFile1.path);
        if (pickedFile2 != null) image2 = File(pickedFile2.path);
        if (pickedFile3 != null) _image3 = File(pickedFile3.path);
      });
    }
  }

  Future<void> _signUp() async {
    if (!_validateInputs()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        // Uri.parse('https://rnrobots.services/api/chat-app-signup/'),
        Uri.parse('https://rnrobots.services/api/chat-app-signup/'),
      );

      request.fields['name'] = _nameController.text.trim();
      request.fields['age'] = _ageController.text.trim();
      request.fields['family_name'] = _familyNameController.text.trim();
      request.fields['device_id'] = _deviceId ?? "unknown";

      List<File?> images = [image1, image2, _image3];
      for (var image in images.where((img) => img != null)) {
        String mimeType = _getMimeType(image!.path);
        var parts = mimeType.split('/');
        request.files.add(
          await http.MultipartFile.fromPath(
            "photos",
            image.path,
            contentType: MediaType(parts[0], parts[1]),
          ),
        );
      }

      var response = await request.send();

      if (response.statusCode == 201) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isRegistered', true);
        await prefs.setString('userName', _nameController.text.trim());
        if (mounted) {
          // Navigate to chat screen after successful registration
          Get.offNamed('/chat', arguments: {
            'greetingMessage': "Welcome, ${_nameController.text.trim()}!",
            'relationship': '',
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Registration failed: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during registration: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  bool _areFieldsFilled() {
    return _nameController.text.isNotEmpty &&
        _ageController.text.isNotEmpty &&
        _familyNameController.text.isNotEmpty;
  }

  bool _validateInputs() {
    if (!_areFieldsFilled()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return false;
    }

    if (int.tryParse(_ageController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid age')),
      );
      return false;
    }

    if (image1 == null || image2 == null || _image3 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please capture all three photos')),
      );
      return false;
    }

    return true;
  }

  String _getMimeType(String filePath) {
    if (filePath.endsWith('.jpg') || filePath.endsWith('.jpeg'))
      return 'image/jpeg';
    if (filePath.endsWith('.png')) return 'image/png';
    return 'application/octet-stream';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                // // Back Button
                // Row(
                //   children: [
                //     IconButton(
                //       icon: const Icon(Icons.arrow_back_ios_new_rounded,
                //           color: gray950, size: 20),
                //       onPressed: () => Get.toNamed('/roleSelection'),
                //       padding: EdgeInsets.zero,
                //       constraints: const BoxConstraints(),
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 10),
                // Logo
                Container(
                  child: Image.asset(
                    bluePlusLogo,
                    width: 120,
                    height: 120,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.local_hospital,
                        size: 40,
                        color: Colors.white,
                      );
                    },
                  ),
                ),

                // Title
                const Text(
                  'Patient Registration',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sign up to connect with healthcare',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 35),

                // Name Field with icon
                _buildInputField(
                  controller: _nameController,
                  hint: 'Name',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 16),

                // Age Field with icon
                _buildInputField(
                  controller: _ageController,
                  hint: 'Age',
                  icon: Icons.calendar_today_outlined,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                // Family Name Field with icon
                _buildInputField(
                  controller: _familyNameController,
                  hint: 'Family Name',
                  icon: Icons.group_outlined,
                ),
                const SizedBox(height: 16),

                // Photo Capture Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: blueCustom.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt_rounded,
                          size: 32,
                          color: blueCustom,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        image1 != null && image2 != null && _image3 != null
                            ? '3 Photos Captured ✓'
                            : 'Verification Photos',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: image1 != null &&
                                  image2 != null &&
                                  _image3 != null
                              ? Colors.green.shade700
                              : const Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Capture 3 photos for verification',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: _capturePhotos,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: blueCustom.withOpacity(0.1),
                            foregroundColor: blueCustom,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.camera_alt_rounded, size: 20),
                          label: const Text(
                            'Open Camera',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    // onPressed: _isSubmitting ? null : _signUp,
                    onPressed: _redirectToChatScreen,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blueCustom,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBackgroundColor: blueCustom.withOpacity(0.6),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // Sign In Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have a account? ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    GestureDetector(
                      onTap: _redirectToChatScreen,
                      child: const Text(
                        // 'Login',
                        'Chat with Doctor',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: blueCustom,
                        ),
                      ),
                    ),
                  ],
                ),
                // const SizedBox(height: 20),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     GestureDetector(
                //       onTap: () {
                //         Get.toNamed('/login');
                //       },
                //       child: const Text(
                //         'Login screen',
                //         style: TextStyle(
                //           fontSize: 14,
                //           fontWeight: FontWeight.w600,
                //           color: blueCustom,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Focus(
      child: Builder(
        builder: (context) {
          final hasFocus = Focus.of(context).hasFocus;
          return Container(
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: hasFocus ? blueCustom : const Color(0xFFE5E7EB),
                width: hasFocus ? 2 : 1,
              ),
            ),
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF1A1A1A),
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: gray500,
                  fontSize: 15,
                ),
                prefixIcon: Icon(
                  icon,
                  color: hasFocus ? blueCustom : const Color(0xFF6B7280),
                  size: 18,
                ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                isDense: true,
              ),
            ),
          );
        },
      ),
    );
  }
}
