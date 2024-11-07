import 'package:flutter/material.dart';
import 'product_form_fields.dart';
import 'image_carousel.dart';

class ProductScreenLayout extends StatelessWidget {
  final bool isEditing;
  final bool isOwner;
  final VoidCallback onSave;
  final ProductFormFields formFields;
  final Widget imageCarousel;
  final bool isLoading;

  const ProductScreenLayout({
    Key? key,
    required this.isEditing,
    required this.isOwner,
    required this.onSave,
    required this.formFields,
    required this.imageCarousel,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? '編集モード' : '商品詳細'),
        actions: [
          if (isOwner)
            isEditing
                ? TextButton(
              onPressed: onSave,
              child: Text('保存', style: TextStyle(color: Colors.white)),
            )
                : IconButton(
              icon: Icon(Icons.edit),
              onPressed: onSave,
            ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            formFields,
            imageCarousel,
          ],
        ),
      ),
    );
  }
}
