import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unitter/screens/setting_screen.dart';
import '../providers/check_version.dart';

class HomeScreen extends StatelessWidget {
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const VersionCheckComponent(),
            Text('Welcome, ${user?.email ?? 'User'}'),
          ],
        ),
      ),
    );
  }
}
