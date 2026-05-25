import 'package:flutter/material.dart';
import '../../../screens/notifications/view/notification_screen.dart';
import 'package:provider/provider.dart';
import '../../api_service/app_url.dart';
import '../../../screens/Profile/view_model/profile_view_model.dart';
import '../../../screens/side_drawer/side_drawer_Screen.dart';
import '../helper_functions/helpers_methods.dart';
import '../navigation_helper.dart';
import 'custom_image_view.dart';
import 'custom_threeDots_indecator.dart';


class CustomHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;

  const CustomHomeAppBar({
    super.key,
    required this.height,
  });


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Consumer<ProfileViewModel>(
          builder: (context, provider, _) {
            final profile = provider.profileData;

            if (profile == null) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: ThreeDotsLoader(),
                ),
              );
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (){
                    navSlideFromRight(
                      context,
                      const SideDrawerScreen(),
                    );
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF006492), width: 2),
                    ),
                    child: ClipOval(
                      child: profile.data?.profileImage != null && profile.data!.profileImage!.isNotEmpty
                          ? Image.network(
                              profile.data!.profileImage!.startsWith('http')
                                  ? profile.data!.profileImage!
                                  : '${AppUrl.baseUrl}/${profile.data!.profileImage!}',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment(0.48, -0.48),
                                      end: Alignment(0.52, 1.48),
                                      colors: [Color(0xFF006492), Color(0xFF2D9CDB)],
                                    ),
                                  ),
                                  child: const Icon(Icons.person, size: 30, color: Colors.white),
                                );
                              },
                            )
                          : Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment(0.48, -0.48),
                                  end: Alignment(0.52, 1.48),
                                  colors: [Color(0xFF006492), Color(0xFF2D9CDB)],
                                ),
                              ),
                              child: const Icon(Icons.person, size: 30, color: Colors.white),
                            ),
                    ),
                  ),
                ),
                // 👋 Emoji Icon
                // CustomImageView(
                //   imagePath: 'assets/icons/helloIcon.png',
                //   height: 40,
                //   width: 40,
                // ),

                // Greeting Text
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                         Text(
                          "Hello, ${HelperMethods.getGreetingMessage()}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          profile.data?.name ?? "NA",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    navSlideFromRight(context, const NotificationScreen());
                  },
                  child: const Icon(Icons.notifications, size: 30),
                ),



                // Profile Icon with Blue Border
                // CustomImageView(
                //   imagePath: 'assets/icons/personHomeIcon.png',
                //   height: 40,
                //   width: 40,
                //   onTap: () {
                //     navSlideFromRight(
                //       context,
                //       const SideDrawerScreen(),
                //     );
                //   },
                // ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
