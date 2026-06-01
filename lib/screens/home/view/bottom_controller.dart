// import 'package:flutter/material.dart';
// import '../../../core/coreServices/deviceInFoGetter.dart';
// import '../../../core/utils/theams/color_resource.dart';
// import '../../appointments/view/appointments_Screen.dart';
// import '../../patients/view/patients_Screen.dart';
// import 'home_screen.dart';
//
//
// import 'package:flutter/material.dart';
// import '../../../core/utils/theams/color_resource.dart';
// import 'home_screen.dart';
//
// class BottomNavController extends StatefulWidget {
//   const BottomNavController({super.key});
//
//   @override
//   BottomNavControllerState createState() => BottomNavControllerState();
// }
//
// class BottomNavControllerState extends State<BottomNavController> {
//   int _currentIndex = 0;
//
//   final List<Widget> _pages = [
//     const HomeScreen(),
//     const AppointmentScreen(isBack: false,),
//     const PatientsScreen(isBack: false,),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       extendBody: true,
//       body: _pages[_currentIndex],
//       bottomNavigationBar: SizedBox(
//         height: screenHeight * 0.12,
//         child: Stack(
//           alignment: Alignment.bottomCenter,
//           children: [
//             // Bottom curved background
//             ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(30),
//                 topRight: Radius.circular(30),
//               ),
//               child: Container(
//                 width: double.infinity,
//                 height: screenHeight * 0.10,
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       ColorResource.gradientLightBlue,
//                       ColorResource.gradientDarkBlue,
//                     ],
//                     begin: Alignment.centerLeft,
//                     end: Alignment.centerRight,
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     _buildBottomNavItem(
//                       icon: Icons.home,
//                       label: 'Home',
//                       index: 0,
//                       isSelected: _currentIndex == 0,
//                     ),
//                     const SizedBox(width: 60), // leave space for center button
//                     _buildBottomNavItem(
//                       icon: Icons.person,
//                       label: 'Patient',
//                       index: 2,
//                       isSelected: _currentIndex == 2,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             // Center elevated circular button
//             Positioned(
//               top: 0,
//               child: GestureDetector(
//                 onTap: () => _onItemTapped(1),
//                 child: Container(
//                   height: 80,
//                   width: 80,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: const LinearGradient(
//                       colors: [
//                         ColorResource.gradientLightBlue,
//                         ColorResource.gradientDarkBlue,
//                       ],
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 8,
//                         offset: Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: const Icon(
//                     Icons.calendar_today_outlined,
//                     size: 32,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBottomNavItem({
//     required IconData icon,
//     required String label,
//     required int index,
//     required bool isSelected,
//   }) {
//     return GestureDetector(
//       onTap: () => _onItemTapped(index),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, color: Colors.white.withOpacity(isSelected ? 1 : 0.6), size: 26),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: TextStyle(
//                 color: Colors.white.withOpacity(isSelected ? 1 : 0.6),
//                 fontSize: 11,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//


import 'dart:io';

import 'package:flutter/material.dart';
import '../../../core/utils/theams/color_resource.dart';
import '../../appointments/view/appointments_Screen.dart';
import '../../patients/view/patients_Screen.dart';
import 'home_screen.dart';

class BottomNavController extends StatefulWidget {
  final int initialIndex;
  const BottomNavController({super.key, this.initialIndex = 0});

  @override
  BottomNavControllerState createState() => BottomNavControllerState();
}

class BottomNavControllerState extends State<BottomNavController> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  // Modern Medical Palette
  static const Color primaryColor = Color(0xFF64B3BA); // Professional Medical Green/Teal
  static const Color inactiveColor = Color(0xFF677294);
  static const Color bgColor = Color(0xFFF8FAFC);

  final List<Widget> _pages = [
    const HomeScreen(),
    const AppointmentScreen(isBack: false),
    const PatientsScreen(isBack: false),
  ];

  void _onItemTapped(int index) {
    if (_currentIndex == index) return;
    setState(() {
      _currentIndex = index;
    });
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: Colors.red.shade400,
                    size: 35,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Exit App",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Are you sure you want to close the application?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 25),

                Row(
                  children: [

                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text("Cancel"),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text(
                          "Exit",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ) ??
        false;
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        bool shouldExit = await _showExitDialog(context);

        if (shouldExit) {
          exit(0);
        }
      },
      child: Scaffold(
        backgroundColor: bgColor,
        extendBody: true, // Allows body to flow behind the rounded nav bar
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: ColoredBox(
            color: Colors.white,
            child: SafeArea(child: _buildBottomBar())),
      ),
    );
  }






  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: bgColor,
  //     extendBody: true, // Allows body to flow behind the rounded nav bar
  //     body: IndexedStack(
  //       index: _currentIndex,
  //       children: _pages,
  //     ),
  //     bottomNavigationBar: ColoredBox(
  //       color: Colors.white,
  //         child: SafeArea(child: _buildBottomBar())),
  //   );
  // }

  Widget _buildBottomBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24), // Floating effect
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x26BEC7D1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Home Item
              _buildNavItem(
                icon: Icons.grid_view_rounded, // More modern than 'home'
                activeIcon: Icons.grid_view_rounded,
                label: 'Home',
                index: 0,
              ),

              // Spacer for center FAB
              const SizedBox(width: 40),

              // Patients Item
              _buildNavItem(
                icon: Icons.people_outline_rounded,
                activeIcon: Icons.people_rounded,
                label: 'Patients',
                index: 2,
              ),
            ],
          ),

          // Center Elevated Button (Appointments)
          Positioned(
            top: 0, // Slight lift
            child: GestureDetector(
              onTap: () => _onItemTapped(1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 60,
                width: 60,
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.48, -0.48),
                    end: Alignment(0.52, 1.48),
                    colors: [const Color(0xFF006492), const Color(0xFF2D9CDB)],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Icon(
                  Icons.calendar_today_rounded,
                  size: 26,
                  color: _currentIndex == 1 ? Colors.white : Colors.white.withOpacity(0.9),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final bool isSelected = _currentIndex == index;

    return InkWell(
      onTap: () => _onItemTapped(index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? ColorResource.primaryColor : inactiveColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            // Minimal Dot Indicator instead of text labels for a cleaner look
            // OR keep text but make it subtle
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: isSelected ? ColorResource.primaryColor : inactiveColor,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
              child: Text(label),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: 4,
                width: 4,
                decoration: const BoxDecoration(
                  color: ColorResource.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}