import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'Image_carousel.dart';

class CustomImagePicker extends StatefulWidget {
  final List<String> initialImageUrls;
  final bool isEditing;
  final Function(Uint8List) onImageSelected;
  final Function(int) onImageRemoved;

  const CustomImagePicker({
    Key? key,
    required this.initialImageUrls,
    required this.isEditing,
    required this.onImageSelected,
    required this.onImageRemoved,
  }) : super(key: key);

  @override
  _CustomImagePickerState createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  late List<String> imageUrls;

  @override
  void initState() {
    super.initState();
    imageUrls = List.from(widget.initialImageUrls); // 初期画像URLをコピー
  }

  Future<void> _pickImages(BuildContext context) async {
    print("DEBUG: Image picker triggered");
    final pickedImages = await ImagePicker().pickMultiImage();

    if (pickedImages != null && pickedImages.isNotEmpty) {
      print("DEBUG: ${pickedImages.length} images selected");
      for (var pickedFile in pickedImages) {
        final imageData = await pickedFile.readAsBytes();
        print("DEBUG: Image data loaded, size: ${imageData.lengthInBytes} bytes");

        // 新しい画像URLを追加（ここでは仮のファイル名を使います）
        setState(() {
          imageUrls.add('data:image/png;base64,' + imageData.toString());
        });
        widget.onImageSelected(imageData); // 外部コールバック
      }
    } else {
      print("DEBUG: No images were selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ImageCarousel(
          imageUrls: imageUrls.isNotEmpty
              ? imageUrls
              : ['assets/images/default_avatar2.png'],
          isEditing: widget.isEditing,
          onDeleteImage: (index) {
            setState(() {
              imageUrls.removeAt(index); // 状態を更新して反映
            });
            widget.onImageRemoved(index); // 外部コールバック
          },
        ),
        if (widget.isEditing)
          Positioned(
            bottom: 10,
            right: 10,
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.8),
              child: IconButton(
                icon: Icon(Icons.camera_alt, color: Colors.blue),
                onPressed: () {
                  print("DEBUG: Camera icon clicked");
                  _pickImages(context);
                },
              ),
            ),
          ),
      ],
    );
  }
}
