import 'dart:typed_data';
import 'package:flutter/material.dart';

class LocalImageCarousel extends StatefulWidget {
  final List<Uint8List> imagesData;
  final bool isEditing;
  final Function(int)? onDeleteImage;

  const LocalImageCarousel({
    Key? key,
    required this.imagesData,
    this.isEditing = false,
    this.onDeleteImage,
  }) : super(key: key);

  @override
  _LocalImageCarouselState createState() => _LocalImageCarouselState();
}

class _LocalImageCarouselState extends State<LocalImageCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 画像スライド
        SizedBox(
          height: 300,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.imagesData.isEmpty ? 1 : widget.imagesData.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final imageData = widget.imagesData.isNotEmpty
                  ? widget.imagesData[index]
                  : null;

              return Stack(
                children: [
                  if (imageData != null)
                    Image.memory(
                      imageData,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  else
                    Image.asset(
                      'assets/images/gray.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  if (widget.isEditing &&
                      widget.onDeleteImage != null &&
                      widget.imagesData.isNotEmpty)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => widget.onDeleteImage!(index),
                      ),
                    ),
                ],
              );
            },
          ),
        ),

        // 左矢印
        if (widget.imagesData.length > 1)
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

        // 右矢印
        if (widget.imagesData.length > 1)
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

        // ドットインジケータ（画像下部中央）
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.imagesData.isEmpty ? 1 : widget.imagesData.length,
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
