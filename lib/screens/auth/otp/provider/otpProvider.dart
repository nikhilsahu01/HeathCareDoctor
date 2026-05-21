import 'dart:async';
import 'package:flutter/material.dart';

import '../../login/repo/login_repository.dart';

class OTPProvider extends ChangeNotifier {
  String _otp = "";
  int timerSeconds = 30;
  bool isResendEnabled = false;
  Timer? _timer;

  OTPProvider() {
    _startTimer();
  }

  void setOTP(String otp) {
    _otp = otp;
    notifyListeners();
  }


  Future<void> resendOTP(String mobileNumber) async {
    isResendEnabled = false; // Disable resend button
    timerSeconds = 30; // Reset timer
    _startTimer(); // Start the timer
    final resendOtpRepository = LoginRepository();
    try {
      var response = await resendOtpRepository.getOtpApi({
        'mobileNumber': mobileNumber,
      });
      if (response['status'] == true) {
        print("OTP resent successfully.");
      } else {
        print("Failed to resend OTP.");
      }
    } catch (e) {
      print("Error resending OTP: $e");
    }

    notifyListeners();
  }


  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timerSeconds > 0) {
        timerSeconds--;
      } else {
        isResendEnabled = true;
        timer.cancel();
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}