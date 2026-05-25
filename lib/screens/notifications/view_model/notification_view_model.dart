import 'package:flutter/material.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String date;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    this.isRead = false,
  });
}

class NotificationViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;

  Future<void> fetchNotifications() async {
    _isLoading = true;
    notifyListeners();

    // Mock API call
    await Future.delayed(const Duration(seconds: 1));

    _notifications = [
      NotificationModel(
        id: "1",
        title: "Appointment Reminder",
        body: "Your appointment with Marcus Chen starts in 15 minutes.",
        date: "Today, 10:15 AM",
        isRead: false,
      ),
      NotificationModel(
        id: "2",
        title: "Profile Approved",
        body: "Your profile has been successfully approved by the admin.",
        date: "Yesterday, 2:30 PM",
        isRead: true,
      ),
      NotificationModel(
        id: "3",
        title: "New Booking",
        body: "A new appointment has been booked for tomorrow.",
        date: "Yesterday, 9:00 AM",
        isRead: true,
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }
}
