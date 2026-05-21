import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 45,
                    width: 45,
                    decoration: ShapeDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.48, -0.48),
                        end: Alignment(0.52, 1.48),
                        colors: [const Color(0xFF006492), const Color(0xFF2D9CDB)],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(48),
                      ),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color:  Colors.white ,
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
                Icon(Icons.notifications,size: 30,),



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
