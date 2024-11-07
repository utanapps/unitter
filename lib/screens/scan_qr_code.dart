import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../components/custom_snack_bar.dart';
import '../generated/l10n.dart';

class ScanQRCode extends StatefulWidget {
  @override
  State<ScanQRCode> createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends State<ScanQRCode> {
  Future<void> scanQRCode(BuildContext context) async {
    try {
      // スキャン開始
      String qrCodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", // スキャン時のUIカラー
        S.of(context).cancelButtonLabel, // キャンセルボタンのテキスト
        true, // フラッシュを使うかどうか
        ScanMode.QR, // スキャンモードをQRに設定
      );

      if (qrCodeScanRes != '-1') {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          builder: (BuildContext context) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 60),
                  SizedBox(height: 16),
                  Text(
                    S.of(context).friendAddedMessage,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                ],
              ),
            );
          },
        );
      }
    } catch (e) {
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).scanErrorMessage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).scanQrCodeTitle),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => scanQRCode(context),
          child: Text(S.of(context).scanTheQrcode),
        ),
      ),
    );
  }
}
