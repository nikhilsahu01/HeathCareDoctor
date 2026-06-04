import 'package:doctors/core/api_service/app_url.dart';
import 'package:doctors/core/utils/custom_widgets/custom_image_view.dart';
import 'package:doctors/core/utils/custom_widgets/custom_threeDots_indecator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctors/core/utils/custom_widgets/custom_appBar.dart';
import 'package:doctors/core/utils/theams/color_resource.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/navigation_helper.dart';
import '../Profile/view/availbility_screen.dart';
import '../Profile/view/loc_availablity.dart';
import '../Profile/view/professional_details_screen.dart';
import '../Profile/view/personal_details_screen.dart';
import '../Profile/view_model/profile_view_model.dart';
import '../splash/splash_screen.dart';
import 'cms_screen.dart';
import '../wallet/ui/walletScreen.dart';



class SideDrawerScreen extends StatefulWidget {
  const SideDrawerScreen({super.key});

  @override
  State<SideDrawerScreen> createState() => _SideDrawerScreenState();
}

class _SideDrawerScreenState extends State<SideDrawerScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ProfileViewModel>(context, listen: false).fetchProfile());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      // backgroundColor: Color(0xffEAF1F1),
      appBar: const CustomAppBar(
        title: 'Profile',
        isProfile: true,
        isBack: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(height: 15,),
                  Consumer<ProfileViewModel>(
                    builder: (context, provider, _) {
                      final profile = provider.profileData;

                      if (profile == null) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: const ThreeDotsLoader(),
                          ),
                        );
                      }
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        // width: double.infinity,
                        // padding: const EdgeInsets.symmetric(
                        //   vertical: 16,
                        //   horizontal: 12,
                        // ),
                        // decoration: BoxDecoration(
                        //   color: Color(0xffE2EDEE),
                        //   borderRadius: BorderRadius.circular(16),
                        //   border: Border.all(color: Colors.white)
                        //
                        // ),
                        child: Column(
                          children: [
                            ClipOval(
                              child:CustomImageView(imagePath:
                                '${AppUrl.baseUrl}/${profile.data?.profileImage??''}',
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                )
                            ),
                            const SizedBox(height: 8),
                            Text(
                              profile.data?.name ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              profile.data?.mobile ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            // const Divider(height: 20),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _menuButton('Personal Details', () {
                    navSlideFromRight(context, const PersonalDetails());
                  }),
                  _menuButton('Professional Details', () {
                    navSlideFromRight(context, const ProfessionalDetailsScreen());
                  }),
                  _menuButton('Location & Availability', () {
                    navSlideFromRight(
                        context, const LocationAvailabilityScreen());
                  }),
                  _menuButton('Schedule Availability', () {
                    navSlideFromRight(
                        context, const AvailabilityTimingScreen());
                  }),
                  _menuButton('Terms & Conditions', () {
                    navSlideFromRight(context, const CmsScreen(title: "Terms & Conditions", cmsKey: "term_condition"));
                  }),
                  _menuButton('Privacy Policy', () {
                    navSlideFromRight(context, const CmsScreen(title: "Privacy Policy", cmsKey: "privacy_policy"));
                  }),
                  _menuButton('About Us', () {
                    navSlideFromRight(context, const CmsScreen(title: "About Us", cmsKey: "about_us"));
                  }),
                  _menuButton('Wallet & Earnings', () {
                    navSlideFromRight(context, const WalletScreen(isToday: false));
                  }),
                  _menuButton('Log Out', () async {
                    bool shouldLogout = await showLogoutDialog(context);
                    if(!shouldLogout) return;
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();
                    navPushRemove(
                      context: context,
                      page: const SplashScreen(),
                    );
                  }),
                  // const SizedBox(height: 20),
                  _menuButton('Delete Account', () async {
                    bool shouldDelete = await showDeleteDialog(context);
                    if(!shouldDelete) return;
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();
                    navPushRemove(
                      context: context,
                      page: const SplashScreen(),
                    );
                  }),
                  const SizedBox(height: 200),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuButton(String title, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_rounded, size: 18),
          ],
        ),
      ),
    );
  }




  Future<bool> showLogoutDialog(BuildContext context) async {
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
                  "Logout",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Are you sure you want to logout from your account?",
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
                          "Logout",
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



  Future<bool> showDeleteDialog(BuildContext context) async {
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
                  "Delete",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Are you sure you want to Delete your account?",
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
                          "Delete",
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



}

