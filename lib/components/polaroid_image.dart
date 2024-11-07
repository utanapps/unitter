// lib/components/polaroid_image.dart

import 'package:flutter/material.dart';

class PolaroidImage extends StatelessWidget {
  final String imageUrl;

  const PolaroidImage({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0), // 枠の内側の余白を設定
      decoration: BoxDecoration(
        color: Colors.white, // 枠の背景色
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400, width: 1), // 枠線を追加
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // 影の色
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(2, 4), // 影の位置
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0), // 画像の角丸
        child: FadeInImage(
          placeholder: AssetImage('assets/images/gray.png'),
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          height: 200,
          width: double.infinity,
        ),
      ),
    );
  }
}
