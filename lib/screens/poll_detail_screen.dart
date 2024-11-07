import 'package:flutter/material.dart';
import '../services/voting_service.dart';

class PollDetailScreen extends StatefulWidget {
  final String pollId;
  PollDetailScreen({required this.pollId});

  @override
  _PollDetailScreenState createState() => _PollDetailScreenState();
}

class _PollDetailScreenState extends State<PollDetailScreen> {
  final votingService = VotingService();
  List<Map<String, dynamic>> options = [];
  bool hasVoted = false;

  @override
  void initState() {
    super.initState();
    fetchResults();
  }

  Future<void> fetchResults() async {
    try {
      options = await votingService.getResults(widget.pollId);
      setState(() {});
      print("デバッグ: 投票結果が正常に取得されました - $options");
    } catch (e) {
      print("デバッグ: 投票結果の取得中にエラーが発生しました - $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("エラーが発生しました: $e")),
      );
    }
  }

  void onVote(String optionId) async {
    print("デバッグ: 投票処理開始");
    try {
      print("デバッグ: pollId - ${widget.pollId}");
      print("デバッグ: optionId - $optionId");

      await votingService.vote(widget.pollId, optionId);

      setState(() {
        hasVoted = true;
      });

      print("デバッグ: 投票完了");
      fetchResults();
    } catch (e) {
      print("デバッグ: 投票中にエラーが発生しました - $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("エラーが発生しました: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalVotes = options.fold<int>(
        0, (previousValue, option) => previousValue + ((option['vote_count'] ?? 0) as num).toInt());

    return Scaffold(
      appBar: AppBar(title: Text("投票詳細")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "選択肢",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...options.map((option) {
              final optionId = option['id'];
              final optionText = option['option_text'] ?? "不明な選択肢";
              final voteCount = (option['vote_count'] ?? 0) as int;
              final votePercentage =
              totalVotes > 0 ? (voteCount / totalVotes * 100).toStringAsFixed(1) : '0';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        optionText,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: totalVotes > 0 ? voteCount / totalVotes : 0,
                        backgroundColor: Colors.grey[300],
                        color: Colors.blue,
                        minHeight: 8,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "$voteCount 票",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "$votePercentage%",
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ),
                          hasVoted
                              ? Text("投票済み",
                              style: TextStyle(
                                  color: Colors.green, fontWeight: FontWeight.bold))
                              : ElevatedButton(
                            onPressed: optionId != null ? () => onVote(optionId) : null,
                            child: Text("投票"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 16),
            hasVoted
                ? Text(
              "ご投票ありがとうございました！",
              style: TextStyle(fontSize: 18, color: Colors.green),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}
