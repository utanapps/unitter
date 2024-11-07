import 'package:flutter_riverpod/flutter_riverpod.dart';

// チャンネルのお気に入り状態を管理するためのプロバイダ
final isFavoriteProvider = StateProvider.family<bool, String>((ref, channelId) {
  // 初期値としては未登録の状態（false）を返す
  return false;
});
