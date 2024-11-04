// //
// // import 'dart:convert';
// // import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// // import 'package:agora_uikit/agora_uikit.dart';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// //
// // class VideoCall extends StatefulWidget {
// //   String channelName = "healthcare";
// //
// //   VideoCall({required this.channelName});
// //   // VideoCall();
// //   @override
// //   _VideoCallState createState() => _VideoCallState();
// // }
// //
// // const appId = "70e6d6d77bd845fc9f08854f4f1fc4e3";
// // String token = "007eJxTYHBrj+DgC/j9kTXw+MkJhQz3szKK9aylL0TZrBMv7GgSnKHAYG6QapZilmJunpRiYWKalmyZZmBhYWqSZpJmmJZskmrcZXU3rSGQkWFtvjkjIwMEgvhcDBmpiTklGcmJRakMDABaTx/A";
// // // String channel = "channel-2";
// //
// // class _VideoCallState extends State<VideoCall> {
// //   int? _remoteUid;
// //   bool _localUserJoined = false;
// //   late RtcEngine _engine;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     initAgora();
// //   }
// //
// //   Future<void> initAgora() async {
// //     // fetch token
// //     // await _fetchToken();
// //
// //     // retrieve permissions
// //     await [Permission.microphone, Permission.camera].request();
// //
// //     //create the engine
// //     _engine = createAgoraRtcEngine();
// //     await _engine.initialize(const RtcEngineContext(
// //       appId: appId,
// //       channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
// //     ));
// //
// //     _engine.registerEventHandler(
// //    EngineEventHandler(
// //         onError: (ErrorCodeType error, String code) {
// //           final info = 'LOG::onError: $code';
// //           debugPrint(info);
// //           print(info);
// //         },
// //         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
// //           debugPrint("local user ${connection.localUid} joined");
// //           setState(() {
// //             _localUserJoined = true;
// //           });
// //         },
// //         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
// //           debugPrint("remote user $remoteUid joined");
// //           setState(() {
// //             _remoteUid = remoteUid;
// //           });
// //         },
// //         onUserOffline: (RtcConnection connection, int remoteUid,
// //             UserOfflineReasonType reason) {
// //           debugPrint("remote user $remoteUid left channel");
// //           setState(() {
// //             _remoteUid = null;
// //           });
// //         },
// //         onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
// //           debugPrint(
// //               '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
// //         },
// //       ),
// //     );
// //
// //     await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
// //     await _engine.enableVideo();
// //     await _engine.startPreview();
// //
// //     await _engine.joinChannel(
// //       token: token,
// //       channelId: widget.channelName,
// //       uid: 0,
// //       options: const ChannelMediaOptions(publishCameraTrack: true),
// //     );
// //     debugPrint("USER JOINED");
// //     debugPrint("${_localUserJoined}");
// //   }
// //
// //   // Future<void> _fetchToken() async {
// //   //   String link =
// //   //       "https://ae7a5c55-1dd9-40b9-aed8-7945d7127043-00-2rcm1dx5px2xq.pike.replit.dev/rtc/${widget.channelName}/publisher/uid/0";
// //   //
// //   //   final response = await http.get(Uri.parse(link), headers: {
// //   //     'Content-Type': 'application/json',
// //   //     'Accept': 'application/json;charset=UTF-8'
// //   //   });
// //   //   // debugPrint("response");
// //   //   // debugPrint(response as String?);
// //   //   if (response.statusCode == 200) {
// //   //     final data = jsonDecode(response.body);
// //   //     // debugPrint("data");
// //   //     // debugPrint(data);
// //   //     setState(() {
// //   //       token = data["rtcToken"];
// //   //       debugPrint("token");
// //   //       debugPrint(token);
// //   //     });
// //   //   } else {
// //   //     // Handle token fetch failure
// //   //     print('Failed to fetch token');
// //   //   }
// //   // }
// //
// //   @override
// //   void dispose() {
// //     super.dispose();
// //
// //     _dispose();
// //   }
// //
// //   Future<void> _dispose() async {
// //     await _engine.leaveChannel();
// //     await _engine.release();
// //   }
// //
// //   // Create UI with local view and remote view
// //   @override
// //   Widget build(BuildContext context) {
// //     final AgoraClient client = AgoraClient(
// //       agoraConnectionData: AgoraConnectionData(
// //           appId: appId, channelName: widget.channelName, tempToken: token),
// //     );
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Agora Video Call'),
// //       ),
// //       body: Stack(
// //         children: [
// //           Center(
// //             child: _remoteVideo(),
// //           ),
// //           Align(
// //             alignment: Alignment.topLeft,
// //             child: SizedBox(
// //               width: 100,
// //               height: 150,
// //               child: Center(
// //                 child: _localUserJoined
// //                     ? AgoraVideoView(
// //                   controller: VideoViewController(
// //                     rtcEngine: _engine,
// //                     canvas: const VideoCanvas(uid: 0),
// //                   ),
// //                 )
// //                     : const CircularProgressIndicator(),
// //               ),
// //             ),
// //           ),
// //           AgoraVideoButtons(
// //             client: client,
// //           )
// //         ],
// //       ),
// //     );
// //   }
// //
// //   // Display remote user's video
// //   Widget _remoteVideo() {
// //     if (_remoteUid != null) {
// //       return AgoraVideoView(
// //         controller: VideoViewController.remote(
// //           rtcEngine: _engine,
// //           canvas: VideoCanvas(uid: _remoteUid),
// //           connection: RtcConnection(channelId: widget.channelName),
// //         ),
// //       );
// //     } else {
// //       return const Text(
// //         'Please wait for remote user to join',
// //         textAlign: TextAlign.center,
// //       );
// //     }
// //   }
// //
// //
// //
// //
// //
//
//
// import 'dart:convert';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:agora_uikit/agora_uikit.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// class VideoCall extends StatefulWidget {
//   String channelName = "healthcare";
//
//   VideoCall({required this.channelName});
//
//   @override
//   _VideoCallState createState() => _VideoCallState();
// }
//
// const appId = "70e6d6d77bd845fc9f08854f4f1fc4e3";
// String token =
//     "007eJxTYHBrj+DgC/j9kTXw+MkJhQz3szKK9aylL0TZrBMv7GgSnKHAYG6QapZilmJunpRiYWKalmyZZmBhYWqSZpJmmJZskmrcZXU3rSGQkWFtvjkjIwMEgvhcDBmpiTklGcmJRakMDABaTx/A";
//
// class _VideoCallState extends State<VideoCall> {
//   int? _remoteUid;
//   bool _localUserJoined = false;
//   late RtcEngine _engine;
//
//   @override
//   void initState() {
//     super.initState();
//     initAgora();
//   }
//
//   Future<void> initAgora() async {
//     // Request necessary permissions
//     await [Permission.microphone, Permission.camera].request();
//
//     // Create the engine
//     _engine = createAgoraRtcEngine();
//     await _engine.initialize(RtcEngineContext(
//       appId: appId,
//       channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//     ));
//
//     // Register event handlers
//     _engine.registerEventHandler(
//       RtcEngineEventHandler(
//         onError: (ErrorCodeType error, String message) {
//           debugPrint('LOG::onError: $message');
//         },
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           debugPrint("local user ${connection.localUid} joined");
//           setState(() {
//             _localUserJoined = true;
//           });
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           debugPrint("remote user $remoteUid joined");
//           setState(() {
//             _remoteUid = remoteUid;
//           });
//         },
//         onUserOffline: (RtcConnection connection, int remoteUid,
//             UserOfflineReasonType reason) {
//           debugPrint("remote user $remoteUid left channel");
//           setState(() {
//             _remoteUid = null;
//           });
//         },
//         onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
//           debugPrint(
//               '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
//         },
//       ),
//     );
//
//     // Set the user role to broadcaster
//     await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
//
//     // Enable video
//     await _engine.enableVideo();
//
//     // Start video preview
//     await _engine.startPreview();
//
//     // Join the channel with a token
//     await _engine.joinChannel(
//       token: token,
//       channelId: widget.channelName,
//       uid: 0,
//       options: const ChannelMediaOptions(
//         publishCameraTrack: true,
//         autoSubscribeAudio: true,
//         autoSubscribeVideo: true,
//       ),
//     );
//     debugPrint("USER JOINED");
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _dispose();
//   }
//
//   Future<void> _dispose() async {
//     await _engine.leaveChannel();
//     await _engine.release();
//   }
//
//   // Create UI with local view and remote view
//   @override
//   Widget build(BuildContext context) {
//     final AgoraClient client = AgoraClient(
//       agoraConnectionData: AgoraConnectionData(
//         appId: appId,
//         channelName: widget.channelName,
//         tempToken: token,
//       ),
//     );
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Agora Video Call'),
//       ),
//       body: Stack(
//         children: [
//           Center(
//             child: _remoteVideo(),
//           ),
//           Align(
//             alignment: Alignment.topLeft,
//             child: SizedBox(
//               width: 100,
//               height: 150,
//               child: Center(
//                 child: _localUserJoined
//                     ? AgoraVideoView(
//                   controller: VideoViewController(
//                     rtcEngine: _engine,
//                     canvas: const VideoCanvas(uid: 0),
//                   ),
//                 )
//                     : const CircularProgressIndicator(),
//               ),
//             ),
//           ),
//           AgoraVideoButtons(
//             client: client,
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Display remote user's video
//   Widget _remoteVideo() {
//     if (_remoteUid != null) {
//       return AgoraVideoView(
//         controller: VideoViewController.remote(
//           rtcEngine: _engine,
//           canvas: VideoCanvas(uid: _remoteUid),
//           connection: RtcConnection(channelId: widget.channelName),
//         ),
//       );
//     } else {
//       return const Text(
//         'Please wait for remote user to join',
//         textAlign: TextAlign.center,
//       );
//     }
//   }
// }


// import 'dart:convert';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:agora_uikit/agora_uikit.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart'; // Make sure to add this dependency
// import 'package:http/http.dart' as http;
//
// class VideoCall extends StatefulWidget {
//   final String channelName;
//
//   VideoCall({required this.channelName});
//
//   @override
//   _VideoCallState createState() => _VideoCallState();
// }
//
// const appId = "70e6d6d77bd845fc9f08854f4f1fc4e3";
// String token = "007eJxTYHBrj+DgC/j9kTXw+MkJhQz3szKK9aylL0TZrBMv7GgSnKHAYG6QapZilmJunpRiYWKalmyZZmBhYWqSZpJmmJZskmrcZXU3rSGQkWFtvjkjIwMEgvhcDBmpiTklGcmJRakMDABaTx/A";
//
// class _VideoCallState extends State<VideoCall> {
//   int? _remoteUid;
//   bool _localUserJoined = false;
//   late RtcEngine _engine;
//
//   @override
//   void initState() {
//     super.initState();
//     initAgora();
//   }
//
//   Future<void> initAgora() async {
//     // Request necessary permissions
//     var statusMic = await Permission.microphone.request();
//     var statusCam = await Permission.camera.request();
//
//     if (statusMic.isDenied || statusCam.isDenied) {
//       // Handle permissions denied
//       debugPrint("Microphone or Camera permission denied.");
//       return;
//     }
//
//     // Create the engine
//     _engine = createAgoraRtcEngine();
//     await _engine.initialize(RtcEngineContext(
//       appId: appId,
//       channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//     ));
//
//     // Register event handlers
//     _engine.registerEventHandler(
//       RtcEngineEventHandler(
//         onError: (ErrorCodeType error, String message) {
//           debugPrint('LOG::onError: $message');
//         },
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           debugPrint("local user ${connection.localUid} joined");
//           setState(() {
//             _localUserJoined = true;
//           });
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           debugPrint("remote user $remoteUid joined");
//           setState(() {
//             _remoteUid = remoteUid;
//           });
//         },
//         onUserOffline: (RtcConnection connection, int remoteUid,
//             UserOfflineReasonType reason) {
//           debugPrint("remote user $remoteUid left channel");
//           setState(() {
//             _remoteUid = null;
//           });
//         },
//         onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
//           debugPrint(
//               '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
//         },
//       ),
//     );
//
//     // Set the user role to broadcaster
//     await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
//
//     // Enable video
//     await _engine.enableVideo();
//
//     // Start video preview
//     await _engine.startPreview();
//
//     // Join the channel with a token
//     await _engine.joinChannel(
//       token: token,
//       channelId: widget.channelName,
//       uid: 0,
//       options: const ChannelMediaOptions(
//         publishCameraTrack: true,
//         autoSubscribeAudio: true,
//         autoSubscribeVideo: true,
//       ),
//     );
//     debugPrint("USER JOINED");
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _dispose();
//   }
//
//   Future<void> _dispose() async {
//     await _engine.leaveChannel();
//     await _engine.release();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final AgoraClient client = AgoraClient(
//       agoraConnectionData: AgoraConnectionData(
//         appId: appId,
//         channelName: widget.channelName,
//         tempToken: token,
//       ),
//     );
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Agora Video Call'),
//       ),
//       body: Stack(
//         children: [
//           Center(
//             child: _remoteVideo(),
//           ),
//           Align(
//             alignment: Alignment.topLeft,
//             child: SizedBox(
//               width: 100,
//               height: 150,
//               child: Center(
//                 child: _localUserJoined
//                     ? AgoraVideoView(
//                   controller: VideoViewController(
//                     rtcEngine: _engine,
//                     canvas: const VideoCanvas(uid: 0),
//                   ),
//                 )
//                     : const CircularProgressIndicator(),
//               ),
//             ),
//           ),
//           AgoraVideoButtons(
//             client: client,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _remoteVideo() {
//     if (_remoteUid != null) {
//       return AgoraVideoView(
//         controller: VideoViewController.remote(
//           rtcEngine: _engine,
//           canvas: VideoCanvas(uid: _remoteUid),
//           connection: RtcConnection(channelId: widget.channelName),
//         ),
//       );
//     } else {
//       return const Text(
//         'Please wait for remote user to join',
//         textAlign: TextAlign.center,
//       );
//     }
//   }
// }




import 'dart:convert';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VideoCall extends StatefulWidget {
  String channelName = "";

  VideoCall({required this.channelName});
  // VideoCall();
  @override
  _VideoCallState createState() => _VideoCallState();
}

const appId = "c66b8f1f20d243eda1021a6699c484d0";
String token = "";
// String channel = "channel-2";

class _VideoCallState extends State<VideoCall> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    // fetch token
    await _fetchToken();

    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onError: (ErrorCodeType error, String code) {
          final info = 'LOG::onError: $code';
          debugPrint(info);
          print(info);
        },
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: token,
      channelId: widget.channelName,
      uid: 0,
      options: const ChannelMediaOptions(publishCameraTrack: true),
    );
    debugPrint("USER JOINED");
    debugPrint("${_localUserJoined}");
  }

  Future<void> _fetchToken() async {
    String link =
        "https://ae7a5c55-1dd9-40b9-aed8-7945d7127043-00-2rcm1dx5px2xq.pike.replit.dev/rtc/${widget.channelName}/publisher/uid/0";

    final response = await http.get(Uri.parse(link), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json;charset=UTF-8'
    });
    // debugPrint("response");
    // debugPrint(response as String?);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // debugPrint("data");
      // debugPrint(data);
      setState(() {
        token = data["rtcToken"];
        debugPrint("token");
        debugPrint(token);
      });
    } else {
      // Handle token fetch failure
      print('Failed to fetch token');
    }
  }

  @override
  void dispose() {
    super.dispose();

    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    final AgoraClient client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
          appId: appId, channelName: widget.channelName, tempToken: token),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
      ),
      body: Stack(
        children: [
          Center(
            child: _remoteVideo(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: Center(
                child: _localUserJoined
                    ? AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: _engine,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                )
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
          AgoraVideoButtons(
            client: client,
          )
        ],
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.channelName),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}