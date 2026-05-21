import 'dart:convert';

import 'package:doctors/core/utils/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../coreServices/deviceInFoGetter.dart';
import 'package:http/http.dart' as http;

class HelperMethods {
  static void showCustomSnackbar(
      BuildContext context, {
        required String message,
        Color backgroundColor = Colors.red,
        Duration duration = const Duration(seconds: 3),
        SnackBarBehavior behavior = SnackBarBehavior.fixed,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: behavior,
      ),
    );
  }

  static void showFloatingToast(
      BuildContext context, {
        required String message,
        Color? color,
      }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 100,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color ?? Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2)).then((_) => overlayEntry.remove());
  }
  static String formatAppointmentDate(String? dateString) {
    if (dateString == null || dateString == 'N/A') return 'N/A';

    try {
      final date = DateTime.parse(dateString).toLocal(); // Convert to local time
      final now = DateTime.now().toLocal();

      // Create date objects without time for comparison
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));
      final yesterday = today.subtract(const Duration(days: 1));
      final appointmentDate = DateTime(date.year, date.month, date.day);

      // Special cases
      if (appointmentDate == today) {
        return 'Today';
      } else if (appointmentDate == tomorrow) {
        return 'Tomorrow';
      } else if (appointmentDate == yesterday) {
        return 'Yesterday';
      }

      // Default formatting for other dates
      final formattedDate = DateFormat('EEE d MMM').format(date);
      return formattedDate;

    } catch (e) {
      print('Error formatting date: $e');
      return 'Invalid Date';
    }
  }
  // static String formatAppointmentDate(String? dateString) {
  //   if (dateString == null || dateString == 'N/A') return 'N/A';
  //
  //   try {
  //     final date = DateTime.parse(dateString);
  //     final formattedDate = DateFormat('EEE d MMM').format(date);
  //     // final formattedDate = DateFormat('EEEE d MMMM').format(date);
  //     return formattedDate;
  //   } catch (e) {
  //     print('Error formatting date: $e');
  //     return 'Invalid Date';
  //   }
  // }
  static Future<XFile?> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      return image;
    } catch (e) {
      debugPrint("Image picking failed: $e");
      return null;
    }
  }

  static Future<XFile?> pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      return image;
    } catch (e) {
      debugPrint("Camera image picking failed: $e");
      return null;
    }
  }

  /// 📸 Show Bottom Sheet Picker (Camera or Gallery)
  static Future<XFile?> showImagePickerOptions(BuildContext context) async {
    return showModalBottomSheet<XFile>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bottomSheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
                  Navigator.of(bottomSheetContext).pop(pickedImage);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? pickedImage = await picker.pickImage(source: ImageSource.camera);
                  Navigator.of(bottomSheetContext).pop(pickedImage);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  // static String getCurrentDateInUtcIsoFormat() {
  //   final now = DateTime.now().toUtc();
  //   return DateFormat("yyyy-MM-dd'T'00:00:00.000'Z'").format(now);
  // }
  // static bool isCurrentTimeWithinTimeSlot(String? timeSlot) {
  //   if (timeSlot == null || !timeSlot.contains(' - ')) return false;
  //
  //   try {
  //     final parts = timeSlot.split(' - ');
  //     final startParts = parts[0].split(':');
  //     final endParts = parts[1].split(':');
  //
  //     final now = DateTime.now();
  //     final startTime = DateTime(now.year, now.month, now.day, int.parse(startParts[0]), int.parse(startParts[1]));
  //     final endTime = DateTime(now.year, now.month, now.day, int.parse(endParts[0]), int.parse(endParts[1]));
  //
  //     return now.isAfter(startTime) && now.isBefore(endTime);
  //   } catch (e) {
  //     print('Error parsing timeSlot: $e');
  //     return false;
  //   }
  // }
  static Future<String?> getDeviceId() async {
    try {
      String? id = await AndroidDeviceInfoService().getAndroidDeviceId();
      print("Fetched Device ID: $id");
      return id;
    } catch (e) {
      print("Error getting device ID: $e");
      return null;
    }
  }

  static Future<Map<String, String>?> getLocationFromPincode(String pincode) async {
    try {
      final url = Uri.parse("https://api.postalpincode.in/pincode/$pincode");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List && data.isNotEmpty && data[0]["Status"] == "Success") {
          final postOffice = data[0]["PostOffice"][0];
          return {
            "district": postOffice["District"] ?? "",
            "state": postOffice["State"] ?? "",
            "country": postOffice["Country"] ?? "India",
          };
        }
      }
      return null;
    } catch (e) {
      debugPrint("Error fetching location from pincode: $e");
      return null;
    }
  }

  static String getGreetingMessage() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon";
    } else if (hour >= 17 && hour < 21) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }

}
