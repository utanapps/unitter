import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unitter/services/supabase_service.dart';
import 'package:unitter/providers/font_size_provider.dart';
import '../providers/supabase_provider.dart';
import '../generated/l10n.dart';
import 'chat_screen.dart';
import '../components/custom_snack_bar.dart';

class ChannelSearchScreen extends ConsumerStatefulWidget {
  const ChannelSearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChannelSearchScreen> createState() => _ChannelSearchScreenState();
}

class _ChannelSearchScreenState extends ConsumerState<ChannelSearchScreen> {
  String? searchChannelName;
  String? selectedPrefectureName;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  List<Map<String, dynamic>> prefectures = [];
  bool isLoadingPrefectures = true;

  @override
  void initState() {
    super.initState();
    fetchPrefectures();
  }

  Future<void> fetchPrefectures() async {
    try {
      final supabaseService = ref.read(supabaseServiceProvider);
      final response = await supabaseService.client.from('prefectures').select();
      if (!mounted) return;
      setState(() {
        prefectures = List<Map<String, dynamic>>.from(response);
        isLoadingPrefectures = false;
      });
    } catch (e) {
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).prefectureFetchError,
      );
      setState(() {
        isLoadingPrefectures = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final supabaseService = ref.read(supabaseServiceProvider);

    return Scaffold(
      body: isLoadingPrefectures
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer(
              builder: (context, ref, child) {
                final fontSize = ref.watch(fontSizeProvider);
                final textColor = Theme.of(context).textTheme.bodyLarge!.color;
                return Column(
                  children: [
                    // チャンネル名検索
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: S.of(context).searchByChannelName,
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onChanged: _onSearchChanged,
                      style: TextStyle(
                        fontSize: fontSize,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 都道府県選択ドロップダウン
                    DropdownButtonFormField<String>(
                      value: selectedPrefectureName,
                      items: [
                        DropdownMenuItem<String>(
                          value: null,
                          child: Text(
                            S.of(context).allPrefectures,
                            style: TextStyle(
                              fontSize: fontSize,
                              color: textColor,
                            ),
                          ),
                        ),
                        ...prefectures.map((prefecture) => DropdownMenuItem<String>(
                          value: prefecture['name'] as String,
                          child: Text(
                            prefecture['name'] as String,
                            style: TextStyle(
                              fontSize: fontSize,
                              color: textColor,
                            ),
                          ),
                        )),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedPrefectureName = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: S.of(context).searchByPrefecture,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      isExpanded: true,
                      style: TextStyle(
                        fontSize: fontSize,
                        color: textColor,
                      ),
                      dropdownColor: Theme.of(context).colorScheme.surface,
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: ChannelList(
              supabaseService: supabaseService,
              searchChannelName: searchChannelName,
              selectedPrefectureName: selectedPrefectureName,
            ),
          ),
        ],
      ),
    );
  }

  // デバウンスを適用した検索関数
  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        searchChannelName = value.isNotEmpty ? value : null;
      });
    });
  }
}

class ChannelList extends StatefulWidget {
  final SupabaseService supabaseService;
  final String? searchChannelName;
  final String? selectedPrefectureName;

  const ChannelList({
    Key? key,
    required this.supabaseService,
    this.searchChannelName,
    this.selectedPrefectureName,
  }) : super(key: key);

  @override
  _ChannelListState createState() => _ChannelListState();
}

class _ChannelListState extends State<ChannelList> {
  late Future<List<Map<String, dynamic>>> _channelsFuture;

  @override
  void initState() {
    super.initState();
    _channelsFuture = fetchChannels(
      widget.supabaseService,
      widget.searchChannelName,
      widget.selectedPrefectureName,
    );
  }

  @override
  void didUpdateWidget(covariant ChannelList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchChannelName != widget.searchChannelName ||
        oldWidget.selectedPrefectureName != widget.selectedPrefectureName) {
      setState(() {
        _channelsFuture = fetchChannels(
          widget.supabaseService,
          widget.searchChannelName,
          widget.selectedPrefectureName,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _channelsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          CustomSnackBar.show(
            ScaffoldMessenger.of(context),
            S.of(context).fetchChannelsError,
          );
          return Center(
            child: Text(S.of(context).fetchChannelsError),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(S.of(context).noChannelsFound),
          );
        } else {
          final channels = snapshot.data!;
          return ListView.builder(
            itemCount: channels.length,
            itemBuilder: (context, index) {
              final channel = channels[index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        channel['avatar_url'] ?? 'assets/images/default_chat_icon.png',
                      ),
                    ),
                    title: Text(channel['name']),
                    subtitle: Text(channel['prefecture'] ?? ''),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            channelId: channel['id'],
                            channelName: channel['name'],
                          ),
                        ),
                      );

                      if (result == true) {
                        setState(() {
                          // リロード処理
                        });
                      }
                    },
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchChannels(SupabaseService supabaseService,
      String? channelName, String? prefectureName) async {
    try {
      var query = supabaseService.client.from('channels').select();

      if (channelName != null && channelName.isNotEmpty) {
        query = query.ilike('name', '%$channelName%');
      }
      if (prefectureName != null && prefectureName.isNotEmpty) {
        query = query.eq('prefecture', prefectureName);
      }

      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).fetchChannelsError,
      );
      return [];
    }
  }
}
