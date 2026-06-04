import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/utils/custom_widgets/custom_appBar.dart';
import '../../../core/utils/theams/color_resource.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: CustomAppBar(
        title: 'settings'.tr(),
        isBack: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'language'.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: context.supportedLocales.length,
                itemBuilder: (context, index) {
                  final locale = context.supportedLocales[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      tileColor: Colors.white,
                      title: Text(locale.toString()),
                      trailing: context.locale == locale
                          ? const Icon(Icons.check_circle, color: ColorResource.primaryColor)
                          : null,
                      onTap: () {
                        context.setLocale(locale);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
