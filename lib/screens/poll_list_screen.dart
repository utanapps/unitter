import 'package:flutter/material.dart';
import '../services/voting_service.dart';
import 'poll_detail_screen.dart';

class PollListScreen extends StatefulWidget {
  @override
  _PollListScreenState createState() => _PollListScreenState();
}

class _PollListScreenState extends State<PollListScreen> {
  final votingService = VotingService();
  List<Map<String, dynamic>> polls = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPolls();
  }

  Future<void> fetchPolls() async {
    try {
      final fetchedPolls = await votingService.getPolls();
      setState(() {
        polls = fetchedPolls;
        isLoading = false;
      });
    } catch (error) {
      print("エラー: 投票の取得に失敗しました - $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("投票一覧"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: polls.length,
        itemBuilder: (context, index) {
          final poll = polls[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 1,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                poll['title'] ?? "タイトルなし",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(poll['description'] ?? "説明なし"),
                  const SizedBox(height: 4),
                  Text(
                    "締切日: ${poll['expires_at'] ?? "未設定"}",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PollDetailScreen(pollId: poll['id']),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
