import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
// 条件付きインポートを使用
import 'web_image_resizer_stub.dart'
if (dart.library.html) 'web_image_resizer_web.dart';

// コールバック関数の型を定義
typedef SingleImageSelectedCallback = void Function(Uint8List imageData, String fileName);
typedef MultipleImagesSelectedCallback = void Function(List<Uint8List> imagesData, List<String> fileNames);

class ImagePickerWidget extends StatefulWidget {
  final SingleImageSelectedCallback? onImageSelected; // 単一画像用
  final MultipleImagesSelectedCallback? onImagesSelected; // 複数画像用
  final String? initialImageUrl;
  final String buttonText;
  final Widget? customButton;
  final String? purpose;
  final bool allowMultiple; // 複数画像を許可するかどうか

  ImagePickerWidget({
    this.onImageSelected,
    this.onImagesSelected,
    this.initialImageUrl,
    this.buttonText = '画像を選択',
    this.customButton,
    this.purpose,
    this.allowMultiple = false,
  }) : assert(
  (allowMultiple && onImagesSelected != null) || (!allowMultiple && onImageSelected != null),
  '適切なコールバック関数を提供してください',
  );

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    if (widget.allowMultiple) {
      // 複数画像選択の場合
      final List<XFile>? pickedFiles = await _picker.pickMultiImage();

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        List<Uint8List> imagesData = [];
        List<String> fileNames = [];

        for (var pickedFile in pickedFiles) {
          final imageData = await pickedFile.readAsBytes();

          // 用途に応じてリサイズを行う
          final resizedImageData = await resizeImageForPurpose(imageData, purpose: widget.purpose);

          // ファイル名にタイムスタンプを追加して一意にする
          String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
          String uniqueFileName = '${timestamp}_${pickedFile.name}.webp';

          imagesData.add(resizedImageData);
          fileNames.add(uniqueFileName);
        }

        // コールバックで画像リストを返す
        widget.onImagesSelected?.call(imagesData, fileNames);
      }
    } else {
      // 単一画像選択の場合
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final imageData = await pickedFile.readAsBytes();

        // 用途に応じてリサイズを行う
        final resizedImageData = await resizeImageForPurpose(imageData, purpose: widget.purpose);

        // ファイル名にタイムスタンプを追加して一意にする
        String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        String uniqueFileName = '${timestamp}_${pickedFile.name}.webp';

        // コールバックで単一の画像を返す
        widget.onImageSelected?.call(resizedImageData, uniqueFileName);
      }
    }
  }

  // リサイズ関数（プラットフォームによって異なる実装を使用）
  Future<Uint8List> resizeImageForPurpose(Uint8List imageData, {String? purpose}) async {
    if (kIsWeb) {
      return await resizeImageForWeb(imageData, purpose: purpose);
    }

    int minWidth = 300;
    int minHeight = 300;

    // 用途ごとにサイズを変更
    switch (widget.purpose) {
      case 'chat':
        minWidth = 300;
        minHeight = 300;
        break;
      case 'avatar':
        minWidth = 100;
        minHeight = 100;
        break;
      case 'marketplace':
        minWidth = 600;
        minHeight = 600;
        break;
    }

    // モバイルの場合のリサイズと圧縮
    return await FlutterImageCompress.compressWithList(
      imageData,
      quality: 80,
      format: CompressFormat.webp,
      minWidth: minWidth,
      minHeight: minHeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.customButton != null
        ? GestureDetector(
      onTap: _pickImage,
      child: widget.customButton,
    )
        : ElevatedButton(
      onPressed: _pickImage,
      child: Text(widget.buttonText),
    );
  }
}
