import 'package:doctors/core/utils/theams/color_resource.dart';
import 'package:flutter/material.dart';
import '../../core/utils/custom_widgets/custom_app_button.dart';
import '../../core/utils/navigation_helper.dart';
import '../auth/login/view/login_screen.dart';


class OBScreen extends StatefulWidget {
  const OBScreen({super.key});

  @override
  State<OBScreen> createState() => _OBScreenState();
}

class _OBScreenState extends State<OBScreen> {
  final List<String> _stickers = [
    'assets/images/OB1.png', // "Appointments Made Easy"
    'assets/images/OB2.png', // "Expert Medical Advice"
  ];

  final List<String> _texts = [
    'Appointments Made Easy.\nCare Made Accessible',
    'Expert Medical Advice,\nJust a Video Call Away',
  ];

  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.1),
            SizedBox(
              height: screenHeight * 0.45,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _stickers.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      _stickers[index],
                      fit: BoxFit.contain,
                      height: screenHeight * 0.4,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
              child: Text(
                _texts[_currentIndex],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.055,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_stickers.length, (index) {
                final isActive = _currentIndex == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: isActive ? 18 : 8,
                  decoration: BoxDecoration(
                    color: isActive ? ColorResource.primaryColor : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
              child: CustomAppButton(
                label: _currentIndex == _stickers.length - 1 ? 'Get Started' : 'Next',
                onPressed: () async{
                  if (_currentIndex == _stickers.length - 1) {
                    navSlideFromRight(context, LoginScreen());
                  } else {
                    _pageController.animateToPage(
                      _currentIndex + 1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}