import 'package:flutter/material.dart';

class NetworkImageCarousel extends StatelessWidget {
  final List<String> imageUrls;
  final bool isEditing;
  final Function(int)? onDeleteImage;

  const NetworkImageCarousel({
    Key? key,
    required this.imageUrls,
    this.isEditing = false,
    this.onDeleteImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: imageUrls.isEmpty ? 1 : imageUrls.length,
            itemBuilder: (context, index) {
              final imageUrl = imageUrls.isNotEmpty
                  ? imageUrls[index]
                  : 'assets/images/gray.png';

              return Stack(
                children: [
                  Image.network(
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
                  if (isEditing && onDeleteImage != null && imageUrls.isNotEmpty)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => onDeleteImage!(index),
                      ),
                    ),
                ],
              );
            },
          ),
          if (imageUrls.length > 1)
            Positioned(
              left: 10,
              top: 130,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Colors.white,
                onPressed: () {
                  PageController().previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
          if (imageUrls.length > 1)
            Positioned(
              right: 10,
              top: 130,
              child: IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                color: Colors.white,
                onPressed: () {
                  PageController().nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
