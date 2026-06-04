import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/custom_widgets/custom_appBar.dart';
import '../../../core/utils/theams/color_resource.dart';
import '../view_model/ticket_view_model.dart';
import '../../../core/utils/custom_widgets/custom_app_button.dart';

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedPriority = "medium";
  File? _selectedFile;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: const CustomAppBar(
        title: 'Create Ticket',
        isBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Subject *", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  hintText: "Enter issue subject",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
                validator: (val) => val == null || val.isEmpty ? "Please enter a subject" : null,
              ),
              const SizedBox(height: 16),
              const Text("Description *", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Describe your issue in detail",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
                validator: (val) => val == null || val.isEmpty ? "Please enter a description" : null,
              ),
              const SizedBox(height: 16),
              const Text("Priority", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedPriority,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: "low", child: Text("Low")),
                      DropdownMenuItem(value: "medium", child: Text("Medium")),
                      DropdownMenuItem(value: "high", child: Text("High")),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedPriority = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Attachment (Optional)", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickFile,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.cloud_upload, color: ColorResource.primaryColor, size: 40),
                      const SizedBox(height: 8),
                      Text(
                        _selectedFile != null ? _selectedFile!.path.split('/').last : "Tap to upload file",
                        style: const TextStyle(color: Colors.black54),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Consumer<TicketViewModel>(
                builder: (context, viewModel, _) {
                  return CustomAppButton(
                    isLoading: viewModel.isLoading,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        bool success = await viewModel.createTicket(
                          context,
                          _subjectController.text.trim(),
                          _descriptionController.text.trim(),
                          _selectedFile,
                          _selectedPriority,
                        );
                        if (success && mounted) {
                          Navigator.pop(context);
                        }
                      }
                    },
                    label: "Submit Ticket",
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
