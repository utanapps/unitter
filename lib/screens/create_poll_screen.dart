import 'package:flutter/material.dart';
import '../services/voting_service.dart';

class CreatePollScreen extends StatefulWidget {
  @override
  _CreatePollScreenState createState() => _CreatePollScreenState();
}

class _CreatePollScreenState extends State<CreatePollScreen> {
  final votingService = VotingService();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final List<TextEditingController> optionControllers = [TextEditingController()];
  DateTime? expiresAt;

  void addOptionField() {
    setState(() {
      optionControllers.add(TextEditingController());
    });
  }

  Future<void> pickExpiryDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          expiresAt = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void createPoll() async {
    final title = titleController.text;
    final description = descriptionController.text;
    final options = optionControllers.map((controller) => controller.text).toList();

    if (expiresAt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("締切日を選択してください")),
      );
      return;
    }

    await votingService.createPoll(title, description, expiresAt!, options);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("投票作成")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTitleDescriptionSection(),
              const SizedBox(height: 16),
              _buildOptionsSection(),
              const SizedBox(height: 16),
              _buildExpiryDateSection(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: createPoll,
                child: Text("作成"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleDescriptionSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "タイトル",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "説明",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "選択肢",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...optionControllers.map((controller) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "選択肢を入力",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            )),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: addOptionField,
              icon: const Icon(Icons.add),  // + アイコンを追加
              label: Text("選択肢を追加"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpiryDateSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "締切日",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,  // 横幅を広げる
              child: ElevatedButton.icon(
                onPressed: pickExpiryDate,
                icon: const Icon(Icons.calendar_today, size: 30),  // 大きなカレンダーアイコンを追加
                label: Text(
                  expiresAt == null
                      ? "締切日を選択"
                      : "選択された締切日: ${expiresAt.toString()}",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
