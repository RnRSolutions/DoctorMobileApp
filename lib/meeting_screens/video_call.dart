import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:chatbot_app/components/constant.dart';
import 'package:get/get.dart';

class VideoCall extends StatefulWidget {
  final String channelName;
  final String token;

  const VideoCall({required this.channelName, required this.token, Key? key})
      : super(key: key);

  @override
  _VideoCallState createState() => _VideoCallState();
}

const appId = "bb736b90ca794cffbd2d86a93cc5ba92";

class _VideoCallState extends State<VideoCall> {
  List<int> _remoteUids = []; // List to track remote user IDs
  bool _localUserJoined = false;
  bool _isLoading = true; // Add loading state
  RtcEngine? _engine;
  bool _isMuted = false;
  bool _isVideoDisabled = false;
  bool _isFrontCamera = true;

  @override
  void initState() {
    super.initState();
    _initAgora();

    // Add timeout to prevent infinite loading
    Future.delayed(const Duration(seconds: 15), () {
      if (mounted && _isLoading) {
        setState(() {
          _isLoading = false;
        });
        Get.snackbar(
          "Connection Timeout",
          "Unable to connect. Please check your internet connection and try again.",
          backgroundColor: Colors.orange.shade50,
          colorText: Colors.orange.shade900,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
        );
      }
    });
  }

  Future<void> _initAgora() async {
    try {
      debugPrint("=== Starting Agora Initialization ===");

      // Request necessary permissions
      debugPrint("Requesting permissions...");
      Map<Permission, PermissionStatus> statuses = await [
        Permission.microphone,
        Permission.camera,
      ].request();

      debugPrint("Camera permission: ${statuses[Permission.camera]}");
      debugPrint("Microphone permission: ${statuses[Permission.microphone]}");

      // Check if permissions were granted
      if (statuses[Permission.camera] != PermissionStatus.granted ||
          statuses[Permission.microphone] != PermissionStatus.granted) {
        debugPrint("❌ Permissions denied!");
        if (mounted) {
          Get.snackbar(
            "Permissions Required",
            "Camera and microphone permissions are required for video calls. Please grant permissions in settings.",
            backgroundColor: Colors.orange.shade50,
            colorText: Colors.orange.shade900,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 5),
          );
        }
        setState(() {
          _isLoading = false;
        });
        return;
      }

      debugPrint("✅ Permissions granted");

      // Initialize the Agora engine
      debugPrint("Creating Agora RTC Engine...");
      _engine = createAgoraRtcEngine();

      debugPrint("Initializing engine with App ID: $appId");
      await _engine!.initialize(
        const RtcEngineContext(
          appId: appId,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ),
      );

      debugPrint("✅ Engine initialized");

      // Register event handlers
      _engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            debugPrint("Local user ${connection.localUid} joined");
            setState(() {
              _localUserJoined = true;
              _isLoading = false; // Stop loading once joined
            });
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            debugPrint("Remote user $remoteUid joined");
            setState(() {
              if (!_remoteUids.contains(remoteUid)) {
                _remoteUids.add(remoteUid);
              }
            });
          },
          onUserOffline: (RtcConnection connection, int remoteUid,
              UserOfflineReasonType reason) {
            debugPrint("Remote user $remoteUid left");
            setState(() {
              _remoteUids.remove(remoteUid);
            });
          },
          onError: (ErrorCodeType err, String msg) {
            debugPrint("Agora Error: $err - $msg");
            setState(() {
              _isLoading = false;
            });

            String errorMessage = "Failed to connect to video call.";

            // Provide specific error messages
            if (err == ErrorCodeType.errInvalidToken ||
                err == ErrorCodeType.errTokenExpired) {
              errorMessage =
                  "Token authentication failed. Please disable App Certificate in Agora Console or use a token server.";
            } else if (err == ErrorCodeType.errConnectionInterrupted ||
                err == ErrorCodeType.errConnectionLost) {
              errorMessage =
                  "Network connection lost. Please check your internet.";
            }

            Get.snackbar(
              "Connection Error",
              "$errorMessage\nError: $msg",
              backgroundColor: Colors.red.shade50,
              colorText: Colors.red.shade900,
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 6),
            );
          },
        ),
      );

      // Set client role and enable video
      debugPrint("Setting client role to broadcaster...");
      await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

      debugPrint("Enabling video...");
      await _engine!.enableVideo();

      debugPrint("Enabling audio...");
      await _engine!.enableAudio();

      debugPrint("Starting camera preview...");
      await _engine!.startPreview();

      debugPrint("✅ Video and audio enabled");

      // Join the channel
      debugPrint("Attempting to join channel...");
      await _joinChannel();
    } catch (e) {
      debugPrint("Error initializing Agora: $e");
      setState(() {
        _isLoading = false;
      });
      Get.snackbar(
        "Error",
        "Failed to initialize video call: $e",
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _joinChannel() async {
    try {
      debugPrint("=== Joining Channel ===");
      debugPrint("Channel Name: ${widget.channelName}");
      debugPrint("Token Mode: TESTING (empty token)");
      debugPrint(
          "⚠️  IMPORTANT: App Certificate MUST be DISABLED in Agora Console!");
      debugPrint("App ID: $appId");

      // For testing without token authentication
      // When you add backend token later, use the token parameter properly
      await _engine!.joinChannel(
        token:
            "", // Testing mode - empty token (App Certificate must be disabled in Agora Console)
        // token: widget.token, // Use this line when you have backend tokens
        channelId: widget.channelName,
        uid: 0,
        options: const ChannelMediaOptions(
          publishCameraTrack: true,
          publishMicrophoneTrack: true,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          autoSubscribeAudio: true,
          autoSubscribeVideo: true,
        ),
      );

      debugPrint("✅ Join channel request sent successfully");
      debugPrint("Waiting for onJoinChannelSuccess callback...");
    } catch (e) {
      debugPrint("Error joining channel: $e");
      setState(() {
        _isLoading = false;
      });

      String errorMsg = e.toString();
      // Commented out token error checking for testing
      // if (errorMsg.contains("token") || errorMsg.contains("401")) {
      //   errorMsg = "Authentication failed. Your Agora app requires a valid token.\n\nTo fix: Go to Agora Console → Project Settings → Disable 'App Certificate' for testing.";
      // }

      Get.snackbar(
        "Connection Failed",
        "Error: $errorMsg\n\nNote: Make sure App Certificate is DISABLED in Agora Console for testing.",
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 8),
      );
    }
  }

  @override
  void dispose() {
    _disposeAgora();
    super.dispose();
  }

  Future<void> _disposeAgora() async {
    if (_engine != null) {
      await _engine!.leaveChannel();
      await _engine!.release();
      _engine = null;
    }
  }

  Future<void> _toggleMute() async {
    setState(() {
      _isMuted = !_isMuted;
    });
    await _engine?.muteLocalAudioStream(_isMuted);
  }

  Future<void> _toggleVideo() async {
    setState(() {
      _isVideoDisabled = !_isVideoDisabled;
    });
    await _engine?.muteLocalVideoStream(_isVideoDisabled);
  }

  Future<void> _switchCamera() async {
    setState(() {
      _isFrontCamera = !_isFrontCamera;
    });
    await _engine?.switchCamera();
  }

  Future<void> _endCall() async {
    await _disposeAgora();
    Get.back();
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color backgroundColor,
    Color iconColor = Colors.white,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: backgroundColor,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: iconColor,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoGrid() {
    List<Widget> videoViews = [];

    // Add local user video
    if (_localUserJoined) {
      videoViews.add(
        AgoraVideoView(
          controller: VideoViewController(
            rtcEngine: _engine!,
            canvas: const VideoCanvas(uid: 0),
          ),
        ),
      );
    }

    // Add remote users' videos
    for (var uid in _remoteUids) {
      videoViews.add(
        AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: _engine!,
            canvas: VideoCanvas(uid: uid),
            connection: RtcConnection(channelId: widget.channelName),
          ),
        ),
      );
    }

    // If no video views available, show placeholder
    if (videoViews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.videocam_off_rounded,
              size: 64,
              color: gray400,
            ),
            const SizedBox(height: 16),
            Text(
              'Waiting for video...',
              style: TextStyle(
                color: gray400,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    // If only one user, show full screen video
    if (videoViews.length == 1) {
      return Center(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: videoViews[0],
        ),
      );
    }

    // Calculate totalUsers for the GridView
    int totalUsers = videoViews.length;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: totalUsers <= 2 ? 1 : 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: totalUsers == 2 ? 1.0 : 0.75,
      ),
      itemCount: totalUsers,
      itemBuilder: (context, index) => videoViews[index],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gray950,
      appBar: AppBar(
        backgroundColor: gray950,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Column(
          children: [
            const Text(
              'Video Call',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              widget.channelName,
              style: TextStyle(
                color: gray400,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: Colors.green.withOpacity(0.5), width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${_remoteUids.length + (_localUserJoined ? 1 : 0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: blueCustom.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: CircularProgressIndicator(
                      color: blueCustom,
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Connecting to call...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Please wait",
                    style: TextStyle(
                      color: gray400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: _buildVideoGrid(),
                    ),
                  ),
                ),
                // Modern Controls Section
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    color: gray950,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Mute button
                        _buildControlButton(
                          icon: _isMuted ? Icons.mic_off : Icons.mic,
                          onPressed: _toggleMute,
                          backgroundColor:
                              _isMuted ? Colors.red : const Color(0xFF374151),
                        ),
                        // Video button
                        _buildControlButton(
                          icon: _isVideoDisabled
                              ? Icons.videocam_off
                              : Icons.videocam,
                          onPressed: _toggleVideo,
                          backgroundColor: _isVideoDisabled
                              ? Colors.red
                              : const Color(0xFF374151),
                        ),
                        // Switch camera button
                        _buildControlButton(
                          icon: Icons.cameraswitch,
                          onPressed: _switchCamera,
                          backgroundColor: const Color(0xFF374151),
                        ),
                        // End call button
                        _buildControlButton(
                          icon: Icons.call_end,
                          onPressed: _endCall,
                          backgroundColor: Colors.red,
                          iconColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
