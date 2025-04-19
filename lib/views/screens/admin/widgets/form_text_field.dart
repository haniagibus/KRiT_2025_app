import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

class FormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int maxLines;

  const FormTextField({
    super.key,
    required this.controller,
    required this.label,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelStyle: TextStyle(color: AppColors.secondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) =>
      value == null || value.trim().isEmpty ? 'Wprowadź $label' : null,
    );
  }
}
