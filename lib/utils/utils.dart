import 'package:flutter/material.dart';

import '../components/message_bottom_sheet.dart';

class Utils {
  static void showMessageBottomSheet(
      BuildContext context,
      String title,
      String message, {
        String buttonText = 'Close',
      }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return MessageBottomSheet(
          title: title,
          message: message,
          buttonText: buttonText,
        );
      },
    );
  }
}
