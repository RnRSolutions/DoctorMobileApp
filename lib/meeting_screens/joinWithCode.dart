import 'package:chatbot_app/meeting_screens/video_call.dart';
import 'package:chatbot_app/components/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JoinWithCode extends StatefulWidget {
  @override
  _JoinWithCodeState createState() => _JoinWithCodeState();
}

class _JoinWithCodeState extends State<JoinWithCode> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: gray950, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Join Meeting",
          style: TextStyle(
            color: gray950,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // Icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: blueCustom.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.meeting_room_rounded,
                  size: 64,
                  color: blueCustom,
                ),
              ),
              const SizedBox(height: 32),
              // Title
              const Text(
                "Enter Meeting Code",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: gray950,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Enter the code provided by the meeting host",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: gray500,
                ),
              ),
              const SizedBox(height: 40),
              // Input Field
              Focus(
                onFocusChange: (hasFocus) {
                  setState(() {});
                },
                child: Builder(
                  builder: (context) {
                    final hasFocus = Focus.of(context).hasFocus;
                    return Container(
                      decoration: BoxDecoration(
                        color: gray50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: hasFocus ? blueCustom : gray300,
                          width: 1.5,
                        ),
                        boxShadow: hasFocus
                            ? [
                                BoxShadow(
                                  color: blueCustom.withOpacity(0.1),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [],
                      ),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2,
                          color: gray950,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "abc-xyz-123",
                          hintStyle: TextStyle(
                            color: gray400,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w400,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              // Join Button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: blueCustom.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      Get.to(() => VideoCall(
                            channelName: _controller.text.trim(),
                            token: "",
                          ));
                    } else {
                      Get.snackbar(
                        "Error",
                        "Please enter a meeting code",
                        backgroundColor: Colors.red.shade50,
                        colorText: Colors.red.shade900,
                        snackPosition: SnackPosition.BOTTOM,
                        margin: const EdgeInsets.all(16),
                        borderRadius: 12,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blueCustom,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Join Meeting",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                  height:
                      MediaQuery.of(context).viewInsets.bottom > 0 ? 20 : 60),
              // Info Text
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: gray50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: gray300.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: gray500, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "The meeting code is usually shared by the host via email or message",
                        style: TextStyle(
                          fontSize: 13,
                          color: gray500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
