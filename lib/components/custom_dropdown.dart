import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final String? selectedValue;
  final List<DropdownMenuItem<String>> items;
  final bool isEditing;
  final Function(String?) onChanged;

  const CustomDropdown({
    Key? key,
    required this.label,
    required this.selectedValue,
    required this.items,
    required this.isEditing,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isEditing
        ? DropdownButtonFormField<String>(
      value: selectedValue,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    )
        : Text(
      '$label: $selectedValue',
      style: TextStyle(fontSize: 16),
    );
  }
}
