import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/supabase_provider.dart';

class FavoriteButton extends ConsumerStatefulWidget {
  final String channelId;

  const FavoriteButton({Key? key, required this.channelId}) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends ConsumerState<FavoriteButton> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final supabaseService = ref.read(supabaseServiceProvider);
    final userId = supabaseService.getCurrentUser()?.id;

    if (userId != null) {
      print("hajimaruyo");
      final isFavorited = await supabaseService.isChannelFavorited(userId, widget.channelId);

      print("isFavorited:${isFavorited}");
      setState(() {
        _isFavorite = isFavorited;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final supabaseService = ref.read(supabaseServiceProvider);
    final userId = supabaseService.getCurrentUser()?.id;

    if (userId != null) {
      await supabaseService.toggleChannelFavorite(userId, widget.channelId, _isFavorite);
      setState(() {
        _isFavorite = !_isFavorite;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
        color: Colors.red,
      ),
      onPressed: _toggleFavorite,
    );
  }
}
