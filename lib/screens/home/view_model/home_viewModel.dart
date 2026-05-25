import 'package:flutter/material.dart';

import '../model/dashboard_model.dart';
import '../repository/home_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final _repository = HomeRepository();
  DashboardModel? _dashboardModel;
  bool _isLoading = false;
  String? _errorMessage;

  int totalAppointments = 0;
  int monthlyAppointments = 0;
  int todayAppointments = 0;
  double profileCompletion = 0.0;

  DashboardModel? get dashboardModel => _dashboardModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchHomeData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.getDashboardApi();
      _dashboardModel = response;

      todayAppointments = response.data?.todayAppointmentsCount ?? 0;
      monthlyAppointments = response.data?.monthlyAppointments ?? 0;
      totalAppointments = response.data?.totalAppointments ?? 0;
      profileCompletion = response.data?.profileCompletion ?? 0.0;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
