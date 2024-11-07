import 'dart:typed_data';

Future<Uint8List> resizeImageForWeb(Uint8List imageData, {String? purpose}) async {
  // モバイルでは特別な処理を行わず、そのまま返すか、必要に応じてモバイル用のリサイズ処理を行う
  return imageData;
}