import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class JoinCallNotifier extends ChangeNotifier {
  final Set<String> _joinableAppointments = {};

  bool canJoin(String appointmentId) => _joinableAppointments.contains(appointmentId);

  void enableJoin(String appointmentId) {
    _joinableAppointments.add(appointmentId);
    notifyListeners();
  }

  void disableJoin(String appointmentId) {
    _joinableAppointments.remove(appointmentId);
    notifyListeners();
  }

  void clearAll() {
    _joinableAppointments.clear();
    notifyListeners();
  }
}
