




import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../core/coreServices/socket_service/join_call_provider.dart';
import '../../core/utils/navigation_helper.dart';
//
// class AgoraVideoCallScreen extends StatefulWidget {
//   final String channelName;
//   final String token;
//   final String appointmentId;
//   final int uid;
//
//   const AgoraVideoCallScreen({
//     Key? key,
//     required this.channelName,
//     required this.token,
//     required this.appointmentId,
//     required this.uid,
//   }) : super(key: key);
//
//   @override
//   State<AgoraVideoCallScreen> createState() => _AgoraVideoCallScreenState();
// }
//
// class _AgoraVideoCallScreenState extends State<AgoraVideoCallScreen> {
//   late RtcEngine _engine;
//   bool _joined = false;
//   bool _muted = false;
//   bool _cameraSwitched = false;
//   bool _hasEndedCall = false;
//
//   // For multi-user support
//   final List<int> _remoteUids = [];   // All remote users
//
//   @override
//   void initState() {
//     super.initState();
//     _initVideoCall();
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     context.read<JoinCallNotifier>().addListener(_checkCanJoinStatus);
//   }
//
//   void _checkCanJoinStatus() {
//     if (!context.read<JoinCallNotifier>().canJoin(widget.appointmentId)) {
//       _endCallAndExit();
//     }
//   }
//
//   Future<void> _endCallAndExit() async {
//     if (_hasEndedCall) return;
//     _hasEndedCall = true;
//     await _engine.leaveChannel();
//     if (mounted) Navigator.pop(context);
//   }
//
//   Future<void> _initVideoCall() async {
//     await [Permission.camera, Permission.microphone].request();
//
//     _engine = createAgoraRtcEngine();
//     await _engine.initialize(const RtcEngineContext(
//       appId: 'a564b76eeb0c4f8cbd1216e06d446ffc',
//       channelProfile: ChannelProfileType.channelProfileCommunication,
//     ));
//
//     _engine.registerEventHandler(RtcEngineEventHandler(
//       onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//         debugPrint("✅ Local user joined: ${connection.localUid}");
//         setState(() => _joined = true);
//       },
//       onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//         debugPrint("✅ Remote user joined: $remoteUid");
//         setState(() {
//           if (!_remoteUids.contains(remoteUid)) {
//             _remoteUids.add(remoteUid);
//           }
//         });
//       },
//       onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
//         debugPrint("❌ Remote user left: $remoteUid");
//         setState(() {
//           _remoteUids.remove(remoteUid);
//         });
//       },
//       onError: (ErrorCodeType err, String msg) {
//         debugPrint("Agora Error: $err - $msg");
//       },
//     ));
//
//     await _engine.enableVideo();
//     await _engine.startPreview();
//
//     await _engine.joinChannel(
//       token: widget.token,
//       channelId: widget.channelName,
//       uid: widget.uid,
//       options: const ChannelMediaOptions(
//         clientRoleType: ClientRoleType.clientRoleBroadcaster,
//         channelProfile: ChannelProfileType.channelProfileCommunication,
//       ),
//     );
//   }
//
//   // Video Views
//   Widget _localVideo() {
//     return AgoraVideoView(
//       controller: VideoViewController(
//         rtcEngine: _engine,
//         canvas: const VideoCanvas(uid: 0),
//       ),
//     );
//   }
//
//   Widget _remoteVideos() {
//     if (_remoteUids.isEmpty) {
//       return const Center(
//         child: Text(
//           "Waiting for others to join...",
//           style: TextStyle(color: Colors.white, fontSize: 18),
//         ),
//       );
//     }
//
//     // 1 Remote User (2 total)
//     if (_remoteUids.length == 1) {
//       return AgoraVideoView(
//         controller: VideoViewController.remote(
//           rtcEngine: _engine,
//           canvas: VideoCanvas(uid: _remoteUids[0]),
//           connection: RtcConnection(channelId: widget.channelName),
//         ),
//       );
//     }
//
//     // 2 Remote Users (3 total) → Grid layout
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         mainAxisSpacing: 4,
//         crossAxisSpacing: 4,
//       ),
//       itemCount: _remoteUids.length,
//       itemBuilder: (context, index) {
//         return AgoraVideoView(
//           controller: VideoViewController.remote(
//             rtcEngine: _engine,
//             canvas: VideoCanvas(uid: _remoteUids[index]),
//             connection: RtcConnection(channelId: widget.channelName),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _toolbar() {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Padding(
//         padding: const EdgeInsets.only(bottom: 40),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             FloatingActionButton(
//               heroTag: 'mute',
//               onPressed: () {
//                 setState(() => _muted = !_muted);
//                 _engine.muteLocalAudioStream(_muted);
//               },
//               backgroundColor: _muted ? Colors.white : Colors.blue,
//               child: Icon(_muted ? Icons.mic_off : Icons.mic,
//                   color: _muted ? Colors.red : Colors.white),
//             ),
//             const SizedBox(width: 20),
//             FloatingActionButton(
//               heroTag: 'end',
//               onPressed: () async {
//                 await _engine.leaveChannel();
//                 if (mounted) navPop(context: context);
//               },
//               backgroundColor: Colors.red,
//               child: const Icon(Icons.call_end),
//             ),
//             const SizedBox(width: 20),
//             FloatingActionButton(
//               heroTag: 'switch',
//               onPressed: () {
//                 setState(() => _cameraSwitched = !_cameraSwitched);
//                 _engine.switchCamera();
//               },
//               backgroundColor: Colors.blue,
//               child: const Icon(Icons.switch_camera),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _engine.leaveChannel();
//     _engine.release();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           // Main Remote Video Area
//           Center(
//             child: _remoteVideos(),
//           ),
//
//           // Local Video (Picture-in-Picture)
//           Positioned(
//             top: 40,
//             right: 16,
//             width: 120,
//             height: 180,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.white70, width: 2),
//                 ),
//                 child: _localVideo(),
//               ),
//             ),
//           ),
//
//           // Toolbar
//           _toolbar(),
//
//           // Participant Count
//           Positioned(
//             top: 50,
//             left: 16,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.6),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 "${_remoteUids.length + 1}/3",
//                 style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



class AgoraVideoCallScreen extends StatefulWidget {
  final String channelName;
  final String token;
  final String appointmentId;
  final int uid;

  const AgoraVideoCallScreen({
    super.key,
    required this.channelName,
    required this.token,
    required this.appointmentId,
    required this.uid,
  });

  @override
  State<AgoraVideoCallScreen> createState() =>
      _AgoraVideoCallScreenState();
}

class _AgoraVideoCallScreenState extends State<AgoraVideoCallScreen> {
  RtcEngine? _engine;

  bool _joined = false;
  bool _muted = false;
  bool _cameraFront = true;

  final List<int> _remoteUids = [];

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  Future<void> _initAgora() async {
    await [Permission.camera, Permission.microphone].request();

    _engine = createAgoraRtcEngine();

    await _engine?.initialize(
      const RtcEngineContext(
        appId: 'a564b76eeb0c4f8cbd1216e06d446ffc',
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );

    _engine?.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (_, __) {
          setState(() => _joined = true);
        },

        onUserJoined: (_, uid, __) {
          setState(() {
            if (!_remoteUids.contains(uid)) {
              _remoteUids.add(uid);
            }
          });
        },

        onUserOffline: (_, uid, __) {
          setState(() {
            _remoteUids.remove(uid);
          });
        },
      ),
    );

    await _engine?.enableVideo();
    await _engine?.startPreview();

    await _engine?.joinChannel(
      token: widget.token,
      channelId: widget.channelName,
      uid: widget.uid,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  // 🟢 LOCAL VIDEO
  Widget _localVideo() {
    if (_engine == null || !_joined) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _engine!,
        canvas: const VideoCanvas(uid: 0),
      ),
    );
  }

  // 🔵 REMOTE VIDEOS (SMART UI)
  Widget _buildVideos() {
    if (_engine == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    int totalUsers = _remoteUids.length + 1;

    if (totalUsers == 1) {
      return const Center(
        child: Text(
          "Waiting for others...",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    if (totalUsers == 2) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine!,
          canvas: VideoCanvas(uid: _remoteUids.first),
          connection: RtcConnection(channelId: widget.channelName),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: AgoraVideoView(
            controller: VideoViewController.remote(
              rtcEngine: _engine!,
              canvas: VideoCanvas(uid: _remoteUids[0]),
              connection: RtcConnection(channelId: widget.channelName),
            ),
          ),
        ),
        Expanded(
          child: AgoraVideoView(
            controller: VideoViewController.remote(
              rtcEngine: _engine!,
              canvas: VideoCanvas(uid: _remoteUids[1]),
              connection: RtcConnection(channelId: widget.channelName),
            ),
          ),
        ),
      ],
    );
  }

  // 🔻 CONTROLS
  Widget _controls() {
    return Positioned(
      bottom: 30,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          /// MIC
          FloatingActionButton(
            heroTag: "mic",
            backgroundColor: _muted ? Colors.white : Colors.blue,
            onPressed: () {
              setState(() => _muted = !_muted);
              _engine?.muteLocalAudioStream(_muted);
            },
            child: Icon(
              _muted ? Icons.mic_off : Icons.mic,
              color: _muted ? Colors.red : Colors.white,
            ),
          ),

          /// END CALL
          FloatingActionButton(
            heroTag: "end",
            backgroundColor: Colors.red,
            onPressed: () async {
              await _engine?.leaveChannel();
              if (mounted) Navigator.pop(context);
            },
            child: const Icon(Icons.call_end),
          ),

          /// SWITCH CAMERA
          FloatingActionButton(
            heroTag: "switch",
            backgroundColor: Colors.blue,
            onPressed: () {
              _engine?.switchCamera();
              setState(() => _cameraFront = !_cameraFront);
            },
            child: const Icon(Icons.switch_camera),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _engine?.leaveChannel();
    _engine?.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_engine == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildVideos(),

          // Local small preview
          Positioned(
            top: 50,
            right: 16,
            width: 120,
            height: 160,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: _localVideo(),
              ),
            ),
          ),

          // Participant count
          Positioned(
            top: 50,
            left: 20,
            child: Text(
              "${_remoteUids.length + 1}/3",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),

          _controls(),
        ],
      ),
    );
  }
}