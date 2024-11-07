// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/supabase_provider.dart';
// import '../services/supabase_service.dart';
//
// // メッセージを取得するプロバイダ
// final fetchMessagesProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, channelId) async {
//   final supabaseService = ref.read(supabaseServiceProvider);
//   return supabaseService.fetchChatMessages(channelId, 5, 0);
// });
//
// // ユーザープロファイルを取得するプロバイダ
// final fetchUserProfileProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
//   final supabaseService = ref.read(supabaseServiceProvider);
//   final userId = supabaseService.getCurrentUser()?.id;
//   if (userId != null) {
//     return supabaseService.getUserProfile(userId);
//   }
//   return {};
// });
