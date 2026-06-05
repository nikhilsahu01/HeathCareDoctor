




import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:simple_pip_mode/simple_pip.dart';
import '../../core/coreServices/socket_service/join_call_provider.dart';
import '../../core/coreServices/socket_service/socket_service.dart';
import '../../core/utils/navigation_helper.dart';
import '../appointments/view/upload_prescription_screen.dart';
import '../../core/api_service/app_url.dart';
import '../../core/api_service/network_api_service.dart';
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
  final bool isDoctor;

  const AgoraVideoCallScreen({
    super.key,
    required this.channelName,
    required this.token,
    required this.appointmentId,
    required this.uid,
    required this.isDoctor
  });

  @override
  State<AgoraVideoCallScreen> createState() =>
      _AgoraVideoCallScreenState();
}

class _AgoraVideoCallScreenState extends State<AgoraVideoCallScreen> {
  RtcEngine? _engine;
  final SimplePip _simplePip = SimplePip();
  bool _callEnded = false;


  bool _joined = false;
  bool _muted = false;
  bool _cameraFront = true;

  final List<int> _remoteUids = [];

  // Chat related
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _chatController = TextEditingController();
  bool _hasUnreadMessages = false;
  late Future doctorFuture;

  @override



  void initState() {
    super.initState();
    _initAgora();

    doctorFuture = NetworkApiServices().postApiWithToken(
      {"categoryid": ""},
      AppUrl.commonDoctorList,
    );
    
    // Listen to chat messages
    SocketService().on("receive-message", (data) {
      if (!mounted) return;
      if (data['appointmentId'] == widget.appointmentId) {
        setState(() {
          _messages.add(data);
          _hasUnreadMessages = true;
        });
      }
    });
  }

  Future<void> _handleCallEnd() async {

    if (_callEnded) return;

    _callEnded = true;

    await _engine?.leaveChannel();

    if (!mounted) return;

    // ONLY DOCTOR
    if (widget.isDoctor) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => UploadPrescriptionScreen(
            appointmentId: widget.appointmentId,
          ),
        ),
      );
    } else {
      Navigator.pop(context);
    }
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


        onUserOffline: (_, uid, __) async {

          setState(() {
            _remoteUids.remove(uid);
          });

          // agar saamne wala user chala gaya
          if (_remoteUids.isEmpty) {
            await _handleCallEnd();
          }
        },

        // onUserOffline: (_, uid, __) {
        //   setState(() {
        //     _remoteUids.remove(uid);
        //   });
        // },
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

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: _remoteUids.length,
      itemBuilder: (context, index) {
        return AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: _engine!,
            canvas: VideoCanvas(uid: _remoteUids[index]),
            connection: RtcConnection(channelId: widget.channelName),
          ),
        );
      },
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
          /// CHAT
          if (widget.isDoctor)
            Stack(
              clipBehavior: Clip.none,
              children: [
              FloatingActionButton(
                heroTag: "chat",
                backgroundColor: Colors.white,
                onPressed: _openChatSheet,
                child: const Icon(Icons.chat, color: Colors.blue),
              ),
              if (_hasUnreadMessages)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                  ),
                ),
            ],
          ),

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
              await _handleCallEnd();
            },
            // onPressed: () async {
            //   await _engine?.leaveChannel();
            //   if (mounted) {
            //     Navigator.pushReplacement(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => UploadPrescriptionScreen(
            //           appointmentId: widget.appointmentId,
            //         ),
            //       ),
            //     );
            //   }
            // },
            child: const Icon(Icons.call_end),
          ),

          /// INVITE DOCTOR
          if (widget.isDoctor)
            FloatingActionButton(
              heroTag: "invite",
              backgroundColor: Colors.orange,
              onPressed: _openInviteSheet,
              child: const Icon(Icons.person_add, color: Colors.white),
            ),

          /// SWITCH CAMERA
          FloatingActionButton(
            heroTag: "switch",
            backgroundColor: Colors.blue,
            onPressed: () async {
              try {
                await _engine?.switchCamera();
                setState(() => _cameraFront = !_cameraFront);
              } catch (e) {
                debugPrint("Camera switch error: $e");
              }
            },
            child: const Icon(Icons.flip_camera_ios),
          ),
        ],
      ),
    );
  }

  void _openChatSheet() {
    setState(() => _hasUnreadMessages = false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(builder: (context, setSheetState) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Chat with Patient", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        final isMe = msg['senderModel'] == 'Vendor';
                        return Align(
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue : Colors.grey.shade200,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                                bottomRight: isMe ? Radius.zero : const Radius.circular(16),
                              ),
                            ),
                            child: Text(
                              msg['message'],
                              style: TextStyle(color: isMe ? Colors.white : Colors.black87),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _chatController,
                            decoration: InputDecoration(
                              hintText: "Type a message...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: IconButton(
                            icon: const Icon(Icons.send, color: Colors.white, size: 20),
                            onPressed: () {
                              if (_chatController.text.trim().isNotEmpty) {
                                final text = _chatController.text.trim();
                                _chatController.clear();
                                SocketService().emit("send-message", {
                                  "appointmentId": widget.appointmentId,
                                  "message": text,
                                  "senderModel": "Vendor"
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  void _openInviteSheet() {

    final TextEditingController searchController = TextEditingController();
    List filteredDoctors = [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(builder: (context, setSheetState) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Invite Doctor", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: doctorFuture,
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return const Center(child: Text("Error fetching doctors"));
                        }
                        final data = snapshot.data;
                        final List doctors = data != null && data['data'] != null ? data['data'] : [];
                        if (searchController.text.isEmpty &&
                            filteredDoctors.isEmpty) {
                          filteredDoctors = List.from(doctors);
                        }
                        if (doctors.isEmpty) {
                          return const Center(child: Text("No doctors available"));
                        }

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: TextField(
                                controller: searchController,
                                decoration: const InputDecoration(
                                  hintText: "Search doctor...",
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  setSheetState(() {

                                    if (value.trim().isEmpty) {
                                      filteredDoctors = List.from(doctors);
                                      return;
                                    }

                                    filteredDoctors = doctors.where((doc) {

                                      final name =
                                      (doc['Name'] ?? '')
                                          .toString()
                                          .toLowerCase();

                                      return name.contains(
                                        value.toLowerCase(),
                                      );

                                    }).toList();

                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: filteredDoctors.length,
                                itemBuilder: (context, index) {
                                  final doc = filteredDoctors[index];
                                  final docId = doc['_id'];
                                  final docName = doc['Name'] ?? 'Unknown';
                                  final docDept = doc['department'] != null && doc['department'].isNotEmpty ? doc['department'][0] : 'General';
                                  final profileImage = doc['profileImage'];
                              
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: profileImage != null && profileImage.toString().isNotEmpty
                                          ? NetworkImage(profileImage.toString())
                                          : null,
                                      child: profileImage == null || profileImage.toString().isEmpty ? const Icon(Icons.person) : null,
                                    ),
                                    title: Text(docName),
                                    subtitle: Text(docDept),
                                    trailing: ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                      onPressed: () {
                                        // Emit socket event to the other doctor
                                        SocketService().emit("invite-doctor", {
                                          "doctorId": docId,
                                          "appointmentId": widget.appointmentId,
                                          "channelName": widget.channelName,
                                          "token": widget.token,
                                        });
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("Invite sent to $docName")),
                                        );
                                      },
                                      child: const Text("Invite", style: TextStyle(color: Colors.white)),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  @override
  void dispose() {
    SocketService().off("receive-message");
    _engine?.leaveChannel();
    _engine?.release();
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        try {
          await _simplePip.enterPipMode();
        } catch (e) {
          debugPrint("PIP Error : $e");
        }
      },
      child: _engine == null
          ? const Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            )
          : Scaffold(
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
    ),
    );
  }
}