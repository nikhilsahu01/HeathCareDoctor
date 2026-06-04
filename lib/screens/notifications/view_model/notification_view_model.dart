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
      _notificationModel?.data ?? [];
  int unreadCount = 0;

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
        _fetchUnreadCount(); // separate fetch for count
      } else {
        print("Failed to fetch notifications: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching notifications: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _fetchUnreadCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return;

      final response = await http.get(
        Uri.parse('${AppUrl.notifications}/unread-count'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        unreadCount = jsonResponse['data']?['unreadCount'] ?? 0;
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching unread count: $e");
    }
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
          if (unreadCount > 0) unreadCount--;
          notifyListeners();
        }
      }
    } catch (e) {
      print("Error marking notification read: $e");
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return;

      final response = await http.patch(
        Uri.parse('${AppUrl.notifications}/read'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        for (var notification in notifications) {
          notification.isRead = true;
        }
        unreadCount = 0;
        notifyListeners();
      }
    } catch (e) {
      print("Error marking all notifications read: $e");
    }
  }

  Future<void> clearAllNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return;

      final response = await http.delete(
        Uri.parse('${AppUrl.notifications}/clear-all'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        notifications.clear();
        unreadCount = 0;
        notifyListeners();
      }
    } catch (e) {
      print("Error clearing notifications: $e");
    }
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
