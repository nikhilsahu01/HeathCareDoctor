import 'package:flutter/material.dart';
import '../navigation_helper.dart';
import '../theams/color_resource.dart';
import 'custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBack;
  final bool isProfile;
  final Widget? action;

  const CustomAppBar({
    super.key,
    required this.title,
    this.isBack = true,
    this.isProfile = false,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = isProfile;
    final themeColor = isDark ? ColorResource.darkText : ColorResource.darkText;

    return Container(
    color: isDark ? ColorResource.white : ColorResource.white,
      width: double.infinity,


      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isBack)
              GestureDetector(
                onTap: () => navPop(context: context),
                child: Container(
                  height: 40,
                  width: 40,
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
                  child: const Icon(Icons.arrow_back, size: 20, color: Colors.white),
                ),
              )
            else
              const SizedBox(width: 40),
            Expanded(
              child: Center(
                child: CustomText(
                  text: title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: themeColor,

                ),
              ),
            ),
            if (action != null)
              action!
            else
              const SizedBox(width: 40),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
