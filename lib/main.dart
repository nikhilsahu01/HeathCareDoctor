
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:doctors/screens/Profile/view_model/profile_view_model.dart';
import 'package:doctors/screens/appointments/viewModel/appointments_details_viewModel.dart';
import 'package:doctors/screens/appointments/viewModel/appointments_viewModel.dart';
import 'package:doctors/screens/auth/registration/viewModel/registration_provider.dart';
import 'package:doctors/screens/home/view_model/home_viewModel.dart';
import 'package:doctors/screens/patients/viewModel/patients_details_viewModel.dart';
import 'package:doctors/screens/patients/viewModel/appointments_viewModel.dart';
import 'package:doctors/screens/splash/splash_screen.dart';
import 'package:doctors/screens/patients/viewModel/appointments_viewModel.dart';
import 'package:doctors/screens/splash/splash_screen.dart';
import 'package:doctors/screens/auth/otp/provider/otpProvider.dart';
import 'package:doctors/screens/wallet/view_model/wallet_view_model.dart';
import 'package:doctors/screens/appointments/viewModel/upload_prescription_view_model.dart';
import 'package:doctors/screens/notifications/view_model/notification_view_model.dart';
import 'package:doctors/screens/tickets/view_model/ticket_view_model.dart';
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
  await EasyLocalization.ensureInitialized();
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
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('fr'), Locale('de'), Locale('es'),
        Locale('it'), Locale('pt'), Locale('ru'),
        Locale('nl'), Locale('pl'), Locale('ar'),
        Locale('tr'), Locale('fa'), Locale('zh', 'CN'),
        Locale('zh', 'TW'), Locale('ja'), Locale('ko'),
        Locale('id'), Locale('th'), Locale('vi'),
        Locale('sw'), Locale('af'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: Locale(Platform.localeName.split('_')[0]),
      child: const MyApp(),
    ),
  );
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
        ChangeNotifierProvider(create: (_) => WalletViewModel()),
        ChangeNotifierProvider(create: (_) => UploadPrescriptionViewModel()),
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
        ChangeNotifierProvider(create: (_) => TicketViewModel()),
      ],
      child: MaterialApp(
        title: 'Doctor',
        navigatorKey: navigatorKey,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}

