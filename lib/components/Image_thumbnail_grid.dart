import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageThumbnailGrid extends StatelessWidget {
  final List<Uint8List> imagesData;
  final void Function(int) onImageTap;

  const ImageThumbnailGrid({
    Key? key,
    required this.imagesData,
    required this.onImageTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: List.generate(imagesData.length, (index) {
        return GestureDetector(
          onTap: () => onImageTap(index),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: MemoryImage(imagesData[index]),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      }),
    );
  }
}
