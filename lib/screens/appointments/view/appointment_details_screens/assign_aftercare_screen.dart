import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/api_service/app_url.dart';
import '../../../../core/utils/custom_widgets/custom_appBar.dart';
import '../../../../core/utils/custom_widgets/custom_app_button.dart';

class AssignAftercareScreen extends StatefulWidget {
  final String patientId;
  final String appointmentId;
  final String patientName;

  const AssignAftercareScreen({
    super.key, 
    required this.patientId, 
    required this.appointmentId,
    required this.patientName
  });

  @override
  State<AssignAftercareScreen> createState() => _AssignAftercareScreenState();
}

class _AssignAftercareScreenState extends State<AssignAftercareScreen> {
  final _instructionsCtrl = TextEditingController();
  final _dietCtrl = TextEditingController();
  final _precautionsCtrl = TextEditingController();
  bool _isLoading = false;
  List<dynamic> _healthLogs = [];

  @override
  void initState() {
    super.initState();
    _fetchHealthLogs();
  }

  Future<void> _fetchHealthLogs() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      var response = await http.get(
        Uri.parse('${AppUrl.baseUrl}/api/vendor/aftercare/health-logs/${widget.patientId}'),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true) {
          setState(() {
            _healthLogs = data['data'];
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching logs: $e");
    }
  }

  Future<void> _submitInstructions() async {
    setState(() => _isLoading = true);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      var response = await http.post(
        Uri.parse('${AppUrl.baseUrl}/api/vendor/aftercare/instruction'),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "patientId": widget.patientId,
          "appointmentId": widget.appointmentId,
          "instructions": _instructionsCtrl.text,
          "dietPlan": _dietCtrl.text,
          "precautions": _precautionsCtrl.text,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Instructions Sent to Patient!")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to send instructions.")),
        );
      }
    } catch (e) {
      debugPrint("Error sending instructions: $e");
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Aftercare: ${widget.patientName}'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Assign Post-Treatment Instructions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _instructionsCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'General Instructions',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _dietCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Diet Plan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _precautionsCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Precautions',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomAppButton(
                    label: "Send to Patient",
                    onPressed: _submitInstructions,
                  ),
            const SizedBox(height: 30),
            const Divider(),
            const Text(
              "Patient's Daily Health Logs",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (_healthLogs.isEmpty)
              const Text("No health logs submitted by patient yet.")
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _healthLogs.length,
                itemBuilder: (context, index) {
                  final log = _healthLogs[index];
                  bool isSevere = log['isSevere'] ?? false;
                  return Card(
                    color: isSevere ? Colors.red.shade50 : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Date: ${log['createdAt']?.toString().substring(0, 10)}"),
                          Text("Pain Level: ${log['painLevel']}/10", style: TextStyle(color: isSevere && log['painLevel'] > 8 ? Colors.red : Colors.black)),
                          Text("Temp: ${log['temperature']} °F", style: TextStyle(color: isSevere && log['temperature'] > 102 ? Colors.red : Colors.black)),
                          Text("BP: ${log['bloodPressure']}"),
                          Text("Sugar: ${log['sugarLevel']}"),
                          if (log['symptoms']?.isNotEmpty ?? false)
                            Text("Symptoms: ${log['symptoms']}"),
                        ],
                      ),
                    ),
                  );
                },
              )
          ],
        ),
      ),
    );
  }
}
