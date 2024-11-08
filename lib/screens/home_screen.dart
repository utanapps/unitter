import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unitter/screens/poll_list_screen.dart';
import 'package:unitter/screens/scan_qr_code.dart';
import 'package:unitter/screens/signin_screen.dart';
import 'package:unitter/services/supabase_service.dart';
import '../providers/supabase_provider.dart';
import 'channel_search_screen.dart';
import 'create_channel_screen.dart';
import 'create_poll_screen.dart';
import 'dashboard_screen.dart';
import 'map_screen.dart';
import 'friends_screen.dart';
import 'marketplace_screen.dart';
import 'notifications_screen.dart';
import 'setting_screen.dart';
import '../generated/l10n.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  late final SupabaseService supabaseService;
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    supabaseService = ref.read(supabaseServiceProvider);
    final user = supabaseService.getCurrentUser();

    if (user != null) {
      supabaseService.setUserToProvider(user.id, ref);
    } else {
      // Delay navigation until after the first frame is rendered
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SigninScreen()),
        );
      });
    }
    supabaseService.setUserToProvider(user!.id, ref);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _widgetOptions = <Widget>[
      const DashBoardScreen(),
      const ChannelSearchScreen(),
      FriendsScreen(),
      PollListScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 150,
        actions: [
          IconButton(
            icon: const Icon(Icons.poll_outlined, color: Colors.black54),  // 投票作成アイコンを追加
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreatePollScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_add, color: Colors.black54),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateChannelScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_2, color: Colors.black54),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScanQRCode()),
              );
            },          ),
          IconButton(
            icon: const Icon(Icons.store_rounded, color: Colors.black54),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MarketplaceScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black54),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black54),
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingScreen()),
              );
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: S.of(context).home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search, color: Colors.black54),
            label: S.of(context).search,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.face, color: Colors.black54),
            label: S.of(context).friends,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_4_rounded, color: Colors.black54),
            label: S.of(context).radar,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        onTap: _onItemTapped,
      ),
    );
  }
}
