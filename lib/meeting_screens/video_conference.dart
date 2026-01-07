import 'package:chatbot_app/meeting_screens/joinWithCode.dart';
import 'package:chatbot_app/meeting_screens/new_meeting.dart';
import 'package:chatbot_app/components/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoConference extends StatelessWidget {
  const VideoConference({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gray50,
      appBar: AppBar(
        title: const Text(
          "Video Conference",
          style: TextStyle(
            color: gray950,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: gray950, size: 20),
          onPressed: () => Get.toNamed('/usersList'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // Title Section
              const Text(
                "Start Your Meeting",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: gray950,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Choose an option to connect with others",
                style: TextStyle(
                  fontSize: 14,
                  color: gray500,
                ),
              ),
              const SizedBox(height: 32),
              // New Meeting Button
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
                    Get.to(() => NewMeeting());
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.video_call_rounded, size: 24),
                      SizedBox(width: 12),
                      Text(
                        "New Meeting",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Join with Code Button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: OutlinedButton(
                  onPressed: () {
                    Get.to(() => JoinWithCode());
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: blueCustom,
                    side: BorderSide(color: gray300, width: 1.5),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.link_rounded, size: 24),
                      SizedBox(width: 12),
                      Text(
                        "Join with a Code",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Info Cards
              Expanded(
                child: Column(
                  children: [
                    _buildInfoCard(
                      icon: Icons.security_rounded,
                      title: "Secure & Private",
                      subtitle: "End-to-end encrypted calls",
                      color: blueCustom,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      icon: Icons.hd_rounded,
                      title: "HD Quality",
                      subtitle: "Crystal clear video & audio",
                      color: blueCustom,
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

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: gray300.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: gray950,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: gray500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
