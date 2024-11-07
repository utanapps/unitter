// import '../services/supabase_service.dart';
//
// Future<void> deleteMessage(
//     String messageId, SupabaseService supabaseService, {String? imageUrl}) async {
//   try {
//     await supabaseService.client
//         .from('chat_messages')
//         .delete()
//         .eq('id', messageId);
//
//     if (imageUrl != null && imageUrl.isNotEmpty) {
//       const bucketName = 'chat';
//       final regex = RegExp(r'\/chat\/(.*)$');
//       final match = regex.firstMatch(imageUrl);
//       if (match != null) {
//         final filePath = match.group(1) ?? '';
//         await supabaseService.deleteImage(
//           bucketName: bucketName,
//           filePath: filePath,
//         );
//       }
//     }
//   } catch (e) {
//     print('メッセージまたは画像削除エラー: $e');
//   }
// }
