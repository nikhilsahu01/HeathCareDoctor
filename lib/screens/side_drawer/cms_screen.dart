import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../core/api_service/app_url.dart';
import '../../core/utils/custom_widgets/custom_appBar.dart';

class CmsScreen extends StatefulWidget {
  final String title;
  final String cmsKey;

  const CmsScreen({super.key, required this.title, required this.cmsKey});

  @override
  State<CmsScreen> createState() => _CmsScreenState();
}

class _CmsScreenState extends State<CmsScreen> {
  bool _isLoading = true;
  String _content = "";

  @override
  void initState() {
    super.initState();
    _fetchCms();
  }

  Future<void> _fetchCms() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse(AppUrl.cms),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true && data['data'] != null && data['data'].isNotEmpty) {
          final cmsData = data['data'][0]; // Assuming first record
          setState(() {
            _content = cmsData[widget.cmsKey] ?? "Content not available.";
            _isLoading = false;
          });
        } else {
          setState(() {
            _content = "Content not available.";
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _content = "Error loading content.";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _content = "An error occurred.";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: widget.title, isBack: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Html(
                data: _content,
                style: {
                  "body": Style(
                    fontSize: FontSize(16.0),
                    color: Colors.black87,
                  ),
                },
              ),
            ),
    );
  }
}
