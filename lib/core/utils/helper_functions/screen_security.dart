// import 'package:flutter_windowmanager/flutter_windowmanager.dart';
//
// class ScreenSecurity {
//   // Call this in initState of your main screen or after login
//   static Future<void> disableScreenshotAndRecording() async {
//     try {
//       await FlutterWindowManager.addFlags(
//         FlutterWindowManager.FLAG_SECURE,
//       );
//       print("✅ Screenshot & Screen Recording Disabled");
//     } catch (e) {
//       print("Failed to disable screenshot: $e");
//     }
//   }
//
//   // Call this when user logs out or you want to re-enable
//   static Future<void> enableScreenshotAndRecording() async {
//     try {
//       await FlutterWindowManager.clearFlags(
//         FlutterWindowManager.FLAG_SECURE,
//       );
//       print("✅ Screenshot & Screen Recording Enabled");
//     } catch (e) {
//       print("Failed to enable screenshot: $e");
//     }
//   }
// }