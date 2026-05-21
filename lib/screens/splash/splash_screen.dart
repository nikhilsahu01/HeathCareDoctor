import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/custom_widgets/custom_image_view.dart';
import '../../core/utils/navigation_helper.dart';
import '../home/view/bottom_controller.dart';
import '../onBoarding/on_boarding_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      navPushRemove(context: context, page: const BottomNavController());
    } else {
      navPushRemove(context: context, page: const OBScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _SplashBody(),
    );
  }
}

class _SplashBody extends StatelessWidget {
  const _SplashBody();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width:MediaQuery.of(context).size.width,
      color: Colors.white,
      child: CustomImageView(
        imagePath: 'assets/images/SplashUpdated.png',
        fit: BoxFit.cover,
        height: MediaQuery.of(context).size.height,
        width:MediaQuery.of(context).size.width,
      ),
    );
  }
}
