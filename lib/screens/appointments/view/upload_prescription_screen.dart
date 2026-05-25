import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/custom_widgets/custom_appBar.dart';
import '../viewModel/upload_prescription_view_model.dart';

class UploadPrescriptionScreen extends StatefulWidget {
  final String appointmentId;

  const UploadPrescriptionScreen({super.key, required this.appointmentId});

  @override
  State<UploadPrescriptionScreen> createState() => _UploadPrescriptionScreenState();
}

class _UploadPrescriptionScreenState extends State<UploadPrescriptionScreen> {
  File? _selectedFile;
  bool _isPdf = false;
  final TextEditingController _notesController = TextEditingController();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
        _isPdf = false;
      });
    }
  }

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _isPdf = result.files.single.extension?.toLowerCase() == 'pdf';
      });
    }
  }

  void _submit() async {
    final vm = Provider.of<UploadPrescriptionViewModel>(context, listen: false);
    bool uploadSuccess = true;
    bool notesSuccess = true;

    if (_selectedFile != null) {
      uploadSuccess = await vm.uploadPrescription(widget.appointmentId, _selectedFile!);
    }

    if (_notesController.text.trim().isNotEmpty) {
      notesSuccess = await vm.saveConsultationNotes(widget.appointmentId, _notesController.text.trim());
    }

    if (mounted) {
      if (uploadSuccess && notesSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Consultation summary saved successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save some items')),
        );
      }
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Consultation Summary"),
      body: Consumer<UploadPrescriptionViewModel>(
        builder: (context, vm, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Add notes and upload a prescription for the patient.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _notesController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Enter consultation notes here...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (ctx) => SafeArea(
                        child: Wrap(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.image),
                              title: const Text('Pick Image'),
                              onTap: () {
                                Navigator.pop(ctx);
                                _pickImage();
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.picture_as_pdf),
                              title: const Text('Pick Document (PDF/Image)'),
                              onTap: () {
                                Navigator.pop(ctx);
                                _pickDocument();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F6F8),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                    ),
                    child: _selectedFile != null
                        ? _isPdf
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.picture_as_pdf, size: 50, color: Colors.red),
                                  SizedBox(height: 10),
                                  Text("PDF Selected", style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(_selectedFile!, fit: BoxFit.cover),
                              )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cloud_upload_outlined, size: 50, color: Color(0xFF156C8A)),
                              SizedBox(height: 10),
                              Text("Tap to Select Prescription", style: TextStyle(color: Color(0xFF156C8A), fontWeight: FontWeight.bold)),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 40),
                if (vm.isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: (_selectedFile == null && _notesController.text.trim().isEmpty) ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006492),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("Save Summary", style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Skip upload
                  },
                  child: const Text("Skip for now", style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
