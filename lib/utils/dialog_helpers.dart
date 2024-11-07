import 'package:flutter/material.dart';
import 'package:unitter/services/supabase_service.dart';
import '../generated/l10n.dart';

Future<bool?> showUsernameDialog(BuildContext context, SupabaseService supabaseService, String userId) {
  final TextEditingController _userNameController = TextEditingController();
  bool _isUsernameAvailable = false;

  void _checkUsernameAvailability() async {
    final username = _userNameController.text.trim();
    if (username.isEmpty || username.length < 2) {
      _isUsernameAvailable = false;
      return;
    }

    try {
      final isAvailable = await supabaseService.client
          .rpc('check_username_availability', params: {'target_username': username});
      _isUsernameAvailable = isAvailable;
    } catch (e) {
      _isUsernameAvailable = false;
    }
  }

  return showDialog<bool>(
    context: context,
    barrierDismissible: true, // ダイアログ外のタップで閉じる
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(S.of(context).setUsernameTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _userNameController,
                  decoration: InputDecoration(
                    labelText: S.of(context).usernameLabel,
                    suffixIcon: _isUsernameAvailable
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const Icon(Icons.error, color: Colors.red),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _checkUsernameAvailability();
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false); // キャンセルボタンでダイアログを閉じる
                },
                child: Text(S.of(context).cancel),
              ),
              ElevatedButton(
                onPressed: _isUsernameAvailable
                    ? () async {
                  try {
                    await supabaseService.client
                        .from('profiles')
                        .update({'username': _userNameController.text.trim()})
                        .eq('id', userId);
                    Navigator.pop(context, true);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(S.of(context).usernameUpdateFailedMessage)),
                    );
                  }
                }
                    : null,
                child: Text(S.of(context).saveButtonText),
              ),
            ],
          );
        },
      );
    },
  ).then((value) => value ?? false);
}
