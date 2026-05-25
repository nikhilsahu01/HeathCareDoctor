import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/api_service/app_url.dart';

class UploadPrescriptionViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> uploadPrescription(String appointmentId, File file) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      var request = http.MultipartRequest('POST', Uri.parse(AppUrl.uploadPrescription));
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });
      request.fields['appointment_id'] = appointmentId;

      request.files.add(await http.MultipartFile.fromPath('prescription', file.path));

      var response = await request.send();

      _isLoading = false;
      notifyListeners();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> saveConsultationNotes(String appointmentId, String notes) async {
    _isLoading = true;
    notifyListeners();

    try {
      // MOCK API: Save Consultation Notes
      await Future.delayed(const Duration(seconds: 1));
      print("MOCK API: Saved notes for appointment $appointmentId -> $notes");

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
