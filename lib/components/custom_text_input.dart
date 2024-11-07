import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isEditing;
  final int? maxLines;
  final String? Function(String?)? validator; // validatorを追加

  const CustomTextInput({
    Key? key,
    required this.controller,
    required this.label,
    required this.isEditing,
    this.maxLines,
    this.validator, // validatorを追加
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      maxLines: maxLines,
      enabled: isEditing,
      validator: validator, // validatorを適用
    );
  }
}
