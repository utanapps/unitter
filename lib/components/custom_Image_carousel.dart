import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'image_picker_widget.dart';

class CustomImageCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final bool isEditing;
  final Function(List<Uint8List>) onImagesAdded;
  final Function(int) onDeleteImage;

  const CustomImageCarousel({
    Key? key,
    required this.imageUrls,
    required this.isEditing,
    required this.onImagesAdded,
    required this.onDeleteImage,
  }) : super(key: key);

  @override
  _CustomImageCarouselState createState() => _CustomImageCarouselState();
}

class _CustomImageCarouselState extends State<CustomImageCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayImages = widget.imageUrls.isNotEmpty
        ? widget.imageUrls
        : ['assets/images/noimage.webp'];

    return Stack(
      children: [
        SizedBox(
          height: 300,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: displayImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final imageUrl = displayImages[index];
              return Stack(
                children: [
                  imageUrl.startsWith('assets/')
                      ? Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                      : Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: Image.asset(
                          'assets/images/noimage.webp',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      );
                    },
                  ),
                  if (widget.isEditing && widget.imageUrls.isNotEmpty)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => widget.onDeleteImage(index),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        if (widget.isEditing)
          Positioned(
            bottom: 10,
            right: 10,
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.8),
              child: ImagePickerWidget(
                allowMultiple: true,
                onImagesSelected: (imagesData, fileNames) {
                  widget.onImagesAdded(imagesData);
                },
                purpose: 'marketplace',
                customButton: Icon(Icons.camera_alt, color: Colors.blue),
              ),
            ),
          ),
        if (displayImages.length > 1)
          Positioned(
            left: 10,
            top: 130,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: () {
                _pageController.previousPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
        if (displayImages.length > 1)
          Positioned(
            right: 10,
            top: 130,
            child: IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              color: Colors.white,
              onPressed: () {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              displayImages.length,
                  (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                width: _currentPage == index ? 12.0 : 8.0,
                height: _currentPage == index ? 12.0 : 8.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? Colors.blue : Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
