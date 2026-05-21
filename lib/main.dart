
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:doctors/screens/Profile/view_model/profile_view_model.dart';
import 'package:doctors/screens/appointments/viewModel/appointments_details_viewModel.dart';
import 'package:doctors/screens/appointments/viewModel/appointments_viewModel.dart';
import 'package:doctors/screens/auth/registration/viewModel/registration_provider.dart';
import 'package:doctors/screens/home/view_model/home_viewModel.dart';
import 'package:doctors/screens/patients/viewModel/patients_details_viewModel.dart';
import 'package:doctors/screens/patients/viewModel/appointments_viewModel.dart';
import 'package:doctors/screens/splash/splash_screen.dart';
import 'package:doctors/screens/auth/otp/provider/otpProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/coreServices/fireBase_services.dart';
import 'core/coreServices/socket_service/join_call_provider.dart';
import 'core/coreServices/socket_service/socket_service.dart';
import 'core/utils/helper_functions/screen_security.dart';
import 'core/utils/theams/app_theme.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await ScreenProtector.preventScreenshotOn(); // ✅ whole app pe apply
  // await ScreenProtector.preventScreenshotOn();  // enable
  // await ScreenProtector.preventScreenshotOff(); // disable
  await Firebase.initializeApp();
  await AwesomeNotifications().initialize(
    null, // icon for notifications (null = default app icon)
 [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',

        channelDescription: 'Notification channel for basic tests',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      ),
    ],
    debug: true,
  );
  await FirebaseNotificationService().init();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  Future.delayed(Duration.zero, () {
    if (token != null && token.isNotEmpty) {
      final socketService = SocketService();
      socketService.connect(userId: token);
      socketService.listenToCallEvents();
    } else {
      print("⚠️ No token found. Skipping socket connection.");
    }
  });
  runApp(const MyApp());
  // ScreenSecurity.disableScreenshotAndRecording();
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OTPProvider()),
        ChangeNotifierProvider(create: (_) => RegistrationProvider()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => AppointmentViewModel()),
        ChangeNotifierProvider(create: (_) => AppointmentDetailsViewModel()),
        ChangeNotifierProvider(create: (_) => PatientsViewModel()),
        ChangeNotifierProvider(create: (_) => PatientsDetailsViewModel()),
        ChangeNotifierProvider(create: (_) => JoinCallNotifier()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
      ],
      child: MaterialApp(
        title: 'Doctor',
        navigatorKey: navigatorKey,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}

