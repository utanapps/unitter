import 'package:flutter/material.dart';

class ProductFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final String category;
  final ValueChanged<String> onCategoryChanged;
  final bool isEditing;

  const ProductFormFields({
    Key? key,
    required this.nameController,
    required this.descriptionController,
    required this.priceController,
    required this.category,
    required this.onCategoryChanged,
    this.isEditing = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'タイトル'),
        ),
        SizedBox(height: 16),
        TextField(
          controller: descriptionController,
          decoration: InputDecoration(labelText: '説明'),
        ),
        SizedBox(height: 16),
        TextField(
          controller: priceController,
          decoration: InputDecoration(labelText: '価格'),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 16),
        DropdownButton<String>(
          value: category,
          hint: Text('カテゴリーを選択'),
          items: ['家電', '服', 'スポーツ用品'].map((category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (category) {
            onCategoryChanged(category!);
          },
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
