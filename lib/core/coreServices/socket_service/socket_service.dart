import 'dart:async';

import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import '../../../main.dart';
import '../../api_service/app_url.dart';
import 'join_call_provider.dart';
import '../../../screens/VideoCall/agoraVideoCall.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();
  Timer? _heartbeatTimer;
  late IO.Socket _socket;
  IO.Socket get socket => _socket;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  void connect({required String userId}) {
    print('📡 Attempting socket connection with userId: $userId');

    _socket = IO.io(
      AppUrl.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setAuth({'token': userId,'role':'doctor'})
          .build(),
    );

    _socket.onConnect((_) {
      _isConnected = true;
      print('✅ Socket connected');
    });

    _socket.onDisconnect((_) {
      _isConnected = false;
      print('🔌 Socket disconnected');
    });

    _socket.onConnectError((data) {
      print("❌ onConnectError: $data");
    });

    _socket.onError((data) {
      print("🛑 onError: $data");
    });

    listenToCallEvents(); // ⚠️ Automatically listen when connected
  }

  void disconnect() {
    _socket.disconnect();
    _isConnected = false;
  }

  void emit(String event, dynamic data) {
    if (_isConnected) {
      _socket.emit(event, data);
    }
  }

  void on(String event, Function(dynamic) callback) {
    _socket.on(event, callback);
  }

  void off(String event) {
    _socket.off(event);
  }

  void _handleJoinCall(String appointmentId) {
    final context = MyApp.navigatorKey.currentContext;
    if (context != null) {
      final notifier = Provider.of<JoinCallNotifier>(context, listen: false);
      notifier.enableJoin(appointmentId);
    }
  }
//
//   /// Internal: Disable UI Join
  void _handleEndCall(String appointmentId) {
    final context = MyApp.navigatorKey.currentContext;
    if (context != null) {
      final notifier = Provider.of<JoinCallNotifier>(context, listen: false);
      notifier.disableJoin(appointmentId);
    }
  }

  void listenToCallEvents() {
    // Enable join button for specific user
    _socket.on('enable-join-button', (data) {
      final userId = data['userId'];
      print('🟢 enable-join-button received for user doctor: $userId');
    });

    // Allow joining call
    _socket.on('join-call', (data) {
      final appointmentId = data['appointmentId'];
      print('📞 join-call for doctor: $appointmentId');

      _handleJoinCall(appointmentId);

      // 🚀 Start emitting heartbeat every 5 seconds
      _startHeartbeat(appointmentId);
    });

    // Heartbeat received from server (optional)
    _socket.on('call-heartbeat', (data) {
      final appointmentId = data['appointmentId'];
      print('💓 call-heartbeat from server for doctor: $appointmentId');
    });

    // End call
    _socket.on('call-ended', (data) {
      final appointmentId = data['appointmentId'];
      print('🔚 call-ended for doctor: $appointmentId');

      _handleEndCall(appointmentId);
      _stopHeartbeat(); // ❌ Stop emitting heartbeat
    });

    // Doctor Invite received
    _socket.on('receive-doctor-invite', (data) {
      final appointmentId = data['appointmentId'];
      final channelName = data['channelName'];
      final token = data['token'];

      print('📩 receive-doctor-invite for appointment: $appointmentId');

      final context = MyApp.navigatorKey.currentContext;
      if (context != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext ctx) {
            return AlertDialog(
              title: const Text('Incoming Consultation Invite'),
              content: const Text('Another doctor is inviting you to join a live consultation.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx); // Close dialog
                  },
                  child: const Text('Reject', style: TextStyle(color: Colors.red)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    Navigator.pop(ctx); // Close dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AgoraVideoCallScreen(
                          channelName: channelName,
                          token: token,
                          appointmentId: appointmentId,
                          uid: 0,
                          isDoctor: true,
                        ),
                      ),
                    );
                  },
                  child: const Text('Join Call', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      }
    });
  }

  /// Start sending heartbeat every 5 seconds
  void _startHeartbeat(String appointmentId) {
    _stopHeartbeat(); // clear any existing timer

    _heartbeatTimer = Timer.periodic(Duration(seconds: 5), (_) {
      print('⏱️ Emitting call-heartbeat for doctor $appointmentId');
      emit('call-heartbeat', {'appointmentId': appointmentId});
    });
  }

  /// Stop heartbeat timer
  void _stopHeartbeat() {
    if (_heartbeatTimer != null) {
      _heartbeatTimer!.cancel();
      _heartbeatTimer = null;
    }
  }
}