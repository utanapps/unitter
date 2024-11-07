import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/supabase_service.dart';
import '../components/marketplace_filter.dart';
import '../generated/l10n.dart';
import '../providers/supabase_provider.dart';
import 'marketplace_post_detail_screen.dart';
import 'create_product_screen.dart';

class MarketplaceScreen extends ConsumerStatefulWidget {
  @override
  _MarketplaceScreenState createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends ConsumerState<MarketplaceScreen> {
  List<Map<String, dynamic>> _posts = [];
  String _selectedCategory = 'all';
  String _selectedStatus = 'all';
  late final SupabaseService supabaseService;

  @override
  void initState() {
    super.initState();
    supabaseService = ref.read(supabaseServiceProvider);
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    try {
      final posts = await supabaseService.getMarketplacePosts(
        category: _selectedCategory != 'all' ? _selectedCategory : null,
        status: _selectedStatus != 'all' ? _selectedStatus : null,
      );
      setState(() {
        _posts = posts;
      });
    } catch (e) {
      print('商品ポスト取得エラー: $e');
    }
  }

  void _onFilterChanged({String? category, String? status}) {
    setState(() {
      if (category != null) _selectedCategory = category;
      if (status != null) _selectedStatus = status;
    });
    _fetchPosts();
  }

  String _getPostPrice(Map<String, dynamic> post) {
    return post['price']?.toString() ?? S.of(context).priceUnknown;
  }

  String _getPostImageUrl(Map<String, dynamic> post) {
    final imageUrls = post['marketplace_post_images'] as List<dynamic>? ?? [];
    return imageUrls.isNotEmpty ? imageUrls.first['image_url'] as String : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).marketplace),
      ),
      body: Column(
        children: [
          MarketplaceFilter(
            selectedCategory: _selectedCategory,
            selectedStatus: _selectedStatus,
            onCategoryChanged: (category) => _onFilterChanged(category: category),
            onStatusChanged: (status) => _onFilterChanged(status: status),
          ),
          Expanded(
            child: _posts.isEmpty
                ? Center(
              child: Text(S.of(context).noPostsAvailable),
            )
                : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                final price = _getPostPrice(post);
                final imageUrl = _getPostImageUrl(post);

                return GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MarketplacePostDetailScreen(
                          postId: post['id']?.toString() ?? '',
                        ),
                      ),
                    );

                    if (result == true) {
                      _fetchPosts();
                    }
                  },
                  child: _buildPostCard(imageUrl, price),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateProductScreen()),
          );

          if (result == true) {
            _fetchPosts(); // 新しい商品が作成された場合に状態を更新
          }
        },
        child: Icon(Icons.add),
        tooltip: S.of(context).addProductTooltip,
      ),
    );
  }

  Widget _buildPostCard(String imageUrl, String price) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          _buildPostImage(imageUrl),
          _buildPriceLabel(price),
        ],
      ),
    );
  }

  Widget _buildPostImage(String imageUrl) {
    return imageUrl.isNotEmpty
        ? Image.network(
      imageUrl,
      width: double.infinity,
      height: 200,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[200],
          child: Image.asset(
            'assets/images/noimage.webp',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        );
      },
    )
        : Container(
      color: Colors.grey[200],
      height: 200,
      child: Icon(Icons.image, size: 60),
    );
  }

  Widget _buildPriceLabel(String price) {
    return Positioned(
      bottom: 16.0,
      right: 16.0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          '¥$price',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
