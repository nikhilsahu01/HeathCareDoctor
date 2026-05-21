import 'package:flutter/material.dart';

import '../model/home_model.dart';
import '../repository/home_repository.dart';

class HomeViewModel extends ChangeNotifier {
  HomeDataModel? _homeDataModel;
  bool _isLoading = false;
  String? _errorMessage;

  // Dummy values
  int totalAppointments = 1994;
  int monthlyAppointments = 18;
  int todayAppointments = 8;
  double profileCompletion = 0.70;

  HomeDataModel? get homeDataModel => _homeDataModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchHomeData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    // Assign dummy values
    totalAppointments = 1994;
    monthlyAppointments = 18;
    todayAppointments = 8;
    profileCompletion = 0.7;

    _isLoading = false;
    notifyListeners();
  }
}
