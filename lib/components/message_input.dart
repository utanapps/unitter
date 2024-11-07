import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:unitter/components/speech_recognition_button.dart';
import 'package:unitter/components/image_picker_widget.dart'; // パスは適宜変更してください

class MessageInput extends StatefulWidget {
  final TextEditingController controller;
  final Future<void> Function(String messageText, Uint8List? imageData, String? imageFileName) onSend;

  const MessageInput({
    Key? key,
    required this.controller,
    required this.onSend,
  }) : super(key: key);

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  Uint8List? _imageData;
  String? _imageFileName;
  bool _isUploading = false;

  void _onImageSelected(Uint8List imageData, String fileName) {
    setState(() {
      _imageData = imageData;
      _imageFileName = fileName;
    });
  }

  void _onSpeechResult(String recognizedText) {
    setState(() {
      widget.controller.text = recognizedText;
    });
  }

  void _sendMessage() async {
    if (widget.controller.text.isNotEmpty || _imageData != null) {
      setState(() {
        _isUploading = true;
      });

      await widget.onSend(widget.controller.text, _imageData, _imageFileName);

      widget.controller.clear();
      setState(() {
        _isUploading = false;
        _imageData = null;
        _imageFileName = null;
      });
    }
  }

  void _clearImage() {
    setState(() {
      _imageData = null;
      _imageFileName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool hasText = widget.controller.text.trim().isNotEmpty;

    return Column(
      children: [
        if (_imageData != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                // 画像プレビュー（角丸に設定）
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.memory(
                    _imageData!,
                    height: 150,
                  ),
                ),
                // 画像削除ボタン
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: _clearImage,
                  ),
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // 画像選択ボタン
              if (_imageData == null)
                ImagePickerWidget(
                  onImageSelected: _onImageSelected,
                  purpose: 'chat', // 用途に応じてリサイズを行う
                  customButton: Icon(Icons.image),
                ),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  decoration: InputDecoration(
                    hintText: 'メッセージを入力...',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      // テキストが変更されたときにUIを更新
                    });
                  },
                ),
              ),
              _isUploading
                  ? CircularProgressIndicator()
                  : hasText
                  ? IconButton(
                icon: Icon(Icons.send),
                onPressed: _sendMessage,
              )
                  : SpeechRecognitionButton(
                onResult: _onSpeechResult,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
