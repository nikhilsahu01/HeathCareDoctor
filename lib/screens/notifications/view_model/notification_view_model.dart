import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:doctors/core/api_service/app_url.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/notification_model.dart';

class NotificationViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  NotificationModel? _notificationModel;
  NotificationModel? get notificationModel => _notificationModel;

  List<NotificationData> get notifications =>
      _notificationModel?.data?.list ?? [];
  int get unreadCount => _notificationModel?.data?.unreadCount ?? 0;

  Future<void> fetchNotifications() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return;

      final response = await http.get(
        Uri.parse(AppUrl.notifications),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        _notificationModel = NotificationModel.fromJson(jsonResponse);
      } else {
        print("Failed to fetch notifications: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching notifications: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> markAsRead(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return;

      final response = await http.patch(
        Uri.parse('${AppUrl.notifications}/read/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final index = notifications.indexWhere((n) => n.sId == id);
        if (index != -1) {
          notifications[index].isRead = true;
          _notificationModel?.data?.unreadCount =
              (_notificationModel?.data?.unreadCount ?? 1) - 1;
          notifyListeners();
        }
      }
    } catch (e) {
      print("Error marking notification read: $e");
    }
  }

  Future<void> markAllAsRead() async {
    // Currently, backend might not have a markAllAsRead endpoint
    // If it does, we can implement it here.
  }
}


class DateTimeHelper {

  static String formatIndianDateTime(String? dateTime) {

    if (dateTime == null || dateTime.isEmpty) {
      return "N/A";
    }

    try {

      // API UTC time parse
      DateTime utcTime = DateTime.parse(dateTime);

      // Local timezone me convert (India me IST)
      DateTime indianTime = utcTime.toLocal();

      // Format
      return DateFormat(
        'dd MMM yyyy, hh:mm a',
      ).format(indianTime);

    } catch (e) {
      return dateTime;
    }
  }
}
