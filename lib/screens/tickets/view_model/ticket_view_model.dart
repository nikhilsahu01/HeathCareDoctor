import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doctors/core/api_service/app_url.dart';
import 'package:doctors/core/utils/helper_functions/helpers_methods.dart';
import 'package:doctors/core/utils/theams/color_resource.dart';
import '../model/ticket_model.dart';

class TicketViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TicketModel? _ticketModel;
  List<TicketData> get tickets => _ticketModel?.data ?? [];

  Future<void> fetchTickets() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return;

      final response = await http.get(
        Uri.parse(AppUrl.ticketList),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        _ticketModel = TicketModel.fromJson(jsonResponse);
      } else {
        print("Failed to fetch tickets: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching tickets: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createTicket(BuildContext context, String subject, String description, File? attachment, String priority) async {
    _isLoading = true;
    notifyListeners();
    bool success = false;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return false;

      var request = http.MultipartRequest('POST', Uri.parse(AppUrl.ticketCreate));
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['subject'] = subject;
      request.fields['description'] = description;
      request.fields['priority'] = priority;

      if (attachment != null) {
        request.files.add(await http.MultipartFile.fromPath('attachment', attachment.path));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        success = true;
        HelperMethods.showFloatingToast(context, message: 'Ticket created successfully', color: ColorResource.green);
        fetchTickets();
      } else {
        final jsonResponse = jsonDecode(response.body);
        HelperMethods.showFloatingToast(context, message: jsonResponse['message'] ?? 'Failed to create ticket', color: ColorResource.red);
      }
    } catch (e) {
      print("Error creating ticket: $e");
      HelperMethods.showFloatingToast(context, message: 'An error occurred', color: ColorResource.red);
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }
}
