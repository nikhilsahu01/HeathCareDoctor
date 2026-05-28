import 'package:flutter/material.dart';
import '../theams/color_resource.dart';




class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool isReadOnly;
  final Function()? onTap;
  final bool isDropdown;
  final List<String>? dropdownItems;
  final int? maxLines;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? initialValue;
  final Function(String)? onChanged;
  final int? maxLength;

  const CustomTextField({
    Key? key,
    required this.label,
    this.controller,
    this.validator,
    this.isReadOnly = false,
    this.onTap,
    this.isDropdown = false,
    this.dropdownItems,
    this.maxLines = 1,
    this.suffixIcon,
    this.keyboardType,
    this.initialValue,
    this.onChanged, // ✅ Accept it
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black)),
        const SizedBox(height: 5),
        isDropdown
            ? DropdownButtonFormField<String>(
          dropdownColor: ColorResource.white,
          value: controller?.text.isNotEmpty == true
              ? controller!.text
              : (initialValue ?? null),
          items: dropdownItems?.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (value) {
            if (controller != null) {
              controller!.text = value ?? '';
            }
            if (onChanged != null && value != null) {
              onChanged!(value); // ✅ Fire callback if provided
            }
          },
          decoration: _inputDecoration(),
          validator: validator,
        )
            : TextFormField(
          cursorColor: Color(0xFF006492),
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          readOnly: isReadOnly,
          onTap: onTap,
          maxLines: maxLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          decoration: _inputDecoration().copyWith(
            suffixIcon: suffixIcon,
          ),
          validator: validator,
          onChanged: onChanged, // ✅ Safe (null is fine)
        ),
      ],
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ColorResource.primaryColor),
      ),
    );
  }
}

class CustomTextFieldProfile extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool isReadOnly;
  final Function()? onTap;
  final bool isDropdown;
  final List<String>? dropdownItems;
  final int? maxLines;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? initialValue;

  /// ✅ New fields
  final String? selectedValue;
  final ValueChanged<String?>? onChanged;
  final int? maxLength;

  const CustomTextFieldProfile({
    Key? key,
    required this.label,
    this.controller,
    this.validator,
    this.isReadOnly = false,
    this.onTap,
    this.isDropdown = false,
    this.dropdownItems,
    this.maxLines = 1,
    this.suffixIcon,
    this.keyboardType,
    this.initialValue,
    this.selectedValue,   // ✅ Added
    this.onChanged,       // ✅ Added
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black)),
        const SizedBox(height: 5),

        // ✅ Dropdown Handling
        isDropdown
            ? DropdownButtonFormField<String>(
          dropdownColor: ColorResource.white,
          value: _getDropdownValue(), // ✅ Normalized value
          items: dropdownItems?.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (value) {
            // ✅ Update controller if passed
            if (controller != null) {
              controller!.text = value ?? '';
            }
            // ✅ Call parent onChanged if passed
            if (onChanged != null) {
              onChanged!(value);
            }
          },
          decoration: _inputDecoration(),
          validator: validator,
        )

        // ✅ TextField Handling
            : TextFormField(
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          readOnly: isReadOnly,
          onTap: onTap,
          maxLines: maxLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          onChanged: onChanged, // ✅ Added missing onChanged for text field
          decoration: _inputDecoration().copyWith(
            suffixIcon: suffixIcon,
          ),
          validator: validator,
        ),
      ],
    );
  }

  /// ✅ Normalize dropdown value from selectedValue > controller > initialValue
  String? _getDropdownValue() {
    if (selectedValue != null && selectedValue!.isNotEmpty) {
      return _normalize(selectedValue!);
    }
    if (controller?.text.isNotEmpty == true) {
      return _normalize(controller!.text);
    }
    return initialValue;
  }

  /// ✅ Helper to normalize gender string
  String _normalize(String value) {
    final text = value.toLowerCase();
    if (text == "male") return "Male";
    if (text == "female") return "Female";
    if (text == "other") return "Other";
    return value;
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ColorResource.primaryColor),
      ),
    );
  }
}
