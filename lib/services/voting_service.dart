import 'package:supabase_flutter/supabase_flutter.dart';

class VotingService {
  final supabase = Supabase.instance.client;

  // 投票作成
  Future<void> createPoll(String title, String description, DateTime expiresAt, List<String> options) async {
    try {
      print(4444444);
      // ログインしているユーザーのチェック
      final user = supabase.auth.currentUser;
      if (user == null) {
        print(5555555);
        throw Exception("ユーザーがログインしていません。");
      }
      print("デバッグ: ユーザーID - ${user.id}");

      // pollsテーブルに新しい投票を挿入
      final pollResponse = await supabase.from('polls').insert({
        'title': title,
        'description': description,
        'created_by': user.id,
        'expires_at': expiresAt.toIso8601String(),
      }).select();
print(6666666);
      if (pollResponse == null || pollResponse.isEmpty) {
        print(7777777);

        throw Exception("投票の作成に失敗しました。");
      }
      print("デバッグ: pollResponse - $pollResponse");
      print(888888888);

      final pollId = pollResponse[0]['id'];
      print("デバッグ: pollId - $pollId");
      print(12121212);

      // 各選択肢を追加
      for (String optionText in options) {
        print("デバッグ: optionText - $optionText");
        final optionResponse = await supabase.from('options').insert({
          'poll_id': pollId,
          'option_text': optionText,
          'vote_count': 0,
        });
        print(13131313);
        //
        // if (optionResponse == null) {
        //   print(14141414);
        //
        //   throw Exception("選択肢「$optionText」の追加に失敗しました。");
        // }
        print("デバッグ: optionResponse - $optionResponse");
      }
      print(13131313);

      print("投票が正常に作成されました。");
    } catch (error) {
      print(1616161616);

      print("投票の作成中にエラーが発生しました: $error");
      rethrow;
    }
  }

  // 投票の一覧を取得
  Future<List<Map<String, dynamic>>> getPolls() async {
    final response = await supabase.from('polls').select('*');
    return response;
  }
  Future<void> vote(String pollId, String optionId) async {
    try {
      // 重複投票を防ぐため、すでに投票したかを確認
      final existingVote = await supabase
          .from('votes')
          .select('*')
          .eq('poll_id', pollId)
          .eq('user_id', supabase.auth.currentUser!.id)
          .maybeSingle(); // 1行のみ取得、見つからない場合はnull

      if (existingVote != null) {
        throw Exception("すでに投票しています");
      }

      // 新しい投票を追加
      await supabase.from('votes').insert({
        'poll_id': pollId,
        'option_id': optionId,
        'user_id': supabase.auth.currentUser!.id,
      });

      // 選択肢のvote_countを増やす
      await supabase.rpc('increment_vote_count', params: {'option_id': optionId});

      print("投票が完了しました");
    } catch (error) {
      print("デバッグ: 投票中にエラーが発生しました - $error");
      throw Exception("$error");
    }
  }


  Future<List<Map<String, dynamic>>> getResults(String pollId) async {
    try {
      final response = await supabase
          .from('options')
          .select('id, option_text, vote_count')
          .eq('poll_id', pollId);

      print("デバッグ: 投票結果が正常に取得されました - $response");
      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      print("デバッグ: 投票結果の取得中にエラーが発生しました - $error");
      throw Exception("データの取得中にエラーが発生しました: $error");
    }
  }


}
