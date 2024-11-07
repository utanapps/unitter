import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechRecognitionButton extends StatefulWidget {
  final void Function(String recognizedText) onResult;

  const SpeechRecognitionButton({Key? key, required this.onResult}) : super(key: key);

  @override
  _SpeechRecognitionButtonState createState() => _SpeechRecognitionButtonState();
}

class _SpeechRecognitionButtonState extends State<SpeechRecognitionButton> {
  SpeechToText _speech = SpeechToText();
  bool _isListening = false;

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val == 'done' || val == 'notListening') {
            setState(() {
              _isListening = false;
            });
            _speech.stop();
          }
        },
        onError: (val) {
          setState(() {
            _isListening = false;
          });
        },
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            widget.onResult(val.recognizedWords);
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _isListening ? Colors.red : Colors.blue,
      ),
      child: IconButton(
        icon: Icon(Icons.mic, color: Colors.white),
        onPressed: _listen,
      ),
    );
  }
}
