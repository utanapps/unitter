import 'dart:typed_data';
import 'package:flutter/material.dart';

class CombinedImageCarousel extends StatefulWidget {
  final List<String> networkImages;
  final List<Uint8List> localImages;
  final bool isEditing;
  final void Function(int)? onDeleteImage;

  const CombinedImageCarousel({
    Key? key,
    required this.networkImages,
    required this.localImages,
    this.isEditing = false,
    this.onDeleteImage,
  }) : super(key: key);

  @override
  _CombinedImageCarouselState createState() => _CombinedImageCarouselState();
}

class _CombinedImageCarouselState extends State<CombinedImageCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // すべての画像（ネットワークとローカル）を一つのリストに統合
    final allImages = [...widget.networkImages, ...widget.localImages];

    return Stack(
      children: [
        // 画像スライド
        SizedBox(
          height: 300,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: allImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final image = allImages[index];
              return Stack(
                children: [
                  if (image is String)
                    Image.network(
                      image,
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
                    )
                  else if (image is Uint8List)
                    Image.memory(
                      image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  if (widget.isEditing && widget.onDeleteImage != null)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          final localIndex = index - widget.networkImages.length;
                          widget.onDeleteImage!(
                              index < widget.networkImages.length ? index : localIndex);
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ),

        // 左矢印
        if (allImages.length > 1)
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
        if (allImages.length > 1)
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
              allImages.length,
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
