import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../components/Image_thumbnail_grid.dart';
import '../components/custom_Image_carousel.dart';
import '../components/image_carousel.dart';
import '../components/custom_text_input.dart';
import '../components/custom_dropdown.dart';
import '../generated/l10n.dart';
import '../providers/supabase_provider.dart';
import '../services/supabase_service.dart';

class MarketplacePostDetailScreen extends ConsumerStatefulWidget {
  final String postId;

  MarketplacePostDetailScreen({required this.postId});

  @override
  _MarketplacePostDetailScreenState createState() =>
      _MarketplacePostDetailScreenState();
}

class _MarketplacePostDetailScreenState
    extends ConsumerState<MarketplacePostDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  bool _isEditing = false;
  bool _isOwner = false;
  String? _currentUserId;
  bool _dataChanged = false;
  String _status = 'available';
  String _category = 'バイク';
  List<String> _imageUrls = [];
  List<Uint8List> _newImagesData = [];
  List<String> _imagesToDelete = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  late final SupabaseService supabaseService;

  @override
  void initState() {
    super.initState();
    supabaseService = ref.read(supabaseServiceProvider);
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _fetchCurrentUserId();
    await _fetchPostDetails();
  }

  Future<void> _fetchCurrentUserId() async {
    final currentUser = supabaseService.getCurrentUser();
    setState(() {
      _currentUserId = currentUser?.id;
    });
  }

  Future<void> _fetchPostDetails() async {
    try {
      final postDetails = await supabaseService.getMarketplacePostDetail(widget.postId);
      if (postDetails != null) {
        setState(() {
          _titleController.text = postDetails['title'] ?? '';
          _descriptionController.text = postDetails['description'] ?? '';
          _priceController.text = (postDetails['price'] as num?)?.toString() ?? '0.0';
          _status = postDetails['status'] ?? 'available';
          _category = postDetails['category'] ?? 'その他';
          _imageUrls = (postDetails['marketplace_post_images'] as List? ?? [])
              .map((image) => image['image_url'] as String)
              .toList();
          _isOwner = postDetails['user_id'] == _currentUserId;
          _isLoading = false;
        });
      } else {
        print("DEBUG: Post details not found");
      }
    } catch (e) {
      print("DEBUG: Error fetching post details - $e");
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    final priceText = _priceController.text;
    final price = double.tryParse(priceText);
    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('有効な価格を入力してください')),
      );
      return;
    }

    List<String> imageUrls = List.from(_imageUrls);
    try {
      // 画像の削除
      for (String imageUrl in _imagesToDelete) {
        await supabaseService.deleteImageFromPost(widget.postId, imageUrl);
      }

      // 新しい画像のアップロード
      for (Uint8List imageData in _newImagesData) {
        String? uploadedImageUrl = await supabaseService.uploadImage(
          bucketName: 'market',
          userId: _currentUserId!,
          imageData: imageData,
          fileName: '${DateTime.now().millisecondsSinceEpoch}.webp',
        );
        if (uploadedImageUrl != null) {
          imageUrls.add(uploadedImageUrl);
          await supabaseService.client.from('marketplace_post_images').insert({
            'post_id': widget.postId,
            'image_url': uploadedImageUrl,
          });
        }
      }

      await supabaseService.updateMarketplacePost(
        postId: widget.postId,
        title: _titleController.text,
        description: _descriptionController.text,
        price: price.toString(),
        category: _category,
        imageUrls: imageUrls,
      );

      setState(() {
        _isEditing = false;
        _dataChanged = true;
        _imageUrls = imageUrls;
        _newImagesData.clear();
        _imagesToDelete.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('投稿が更新されました')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('更新に失敗しました')),
      );
    }
  }
  void _removeThumbnailImage(int index) {
    setState(() {
      _newImagesData.removeAt(index);
    });
  }

  void _addNewImages(List<Uint8List> imagesData) {
    setState(() {
      _newImagesData.addAll(imagesData);
      _dataChanged = true;
    });
  }

  void _removeImage(int index) {
    setState(() {
      _imagesToDelete.add(_imageUrls[index]);
      _imageUrls.removeAt(index);
      _dataChanged = true;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_dataChanged);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? S.of(context).editMode : _titleController.text),
          actions: _isOwner
              ? [
            _isEditing
                ? TextButton(
              onPressed: _saveChanges,
              child: Text(S.of(context).save),
            )
                : IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
          ]
              : null,
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomImageCarousel(
                  imageUrls: _imageUrls.isNotEmpty ? _imageUrls : ['assets/images/gray.png'],
                  isEditing: _isEditing,
                  onImagesAdded: _addNewImages, // 新しい画像が選択されたときに呼ばれる
                  onDeleteImage: _removeImage, // 画像を削除するときに呼ばれる
                ),
                const SizedBox(height: 16),
                if (_newImagesData.isNotEmpty)
                  ImageThumbnailGrid(
                    imagesData: _newImagesData,
                    onImageTap: _removeThumbnailImage,
                  ),
                // if (_newImagesData.isNotEmpty)
                //   Wrap(
                //     spacing: 8.0,
                //     runSpacing: 8.0,
                //     children: _newImagesData.map((imageData) {
                //       return Container(
                //         width: 100,
                //         height: 100,
                //         decoration: BoxDecoration(
                //           border: Border.all(color: Colors.grey),
                //           borderRadius: BorderRadius.circular(8.0),
                //           image: DecorationImage(
                //             image: MemoryImage(imageData),
                //             fit: BoxFit.cover,
                //           ),
                //         ),
                //       );
                //     }).toList(),


                const SizedBox(height: 16),
                CustomTextInput(
                  controller: _titleController,
                  label: 'タイトル',
                  isEditing: _isEditing,
                ),
                const SizedBox(height: 16),
                CustomTextInput(
                  controller: _priceController,
                  label: '価格',
                  isEditing: _isEditing,
                ),
                const SizedBox(height: 16),
                CustomDropdown(
                  label: 'カテゴリ',
                  selectedValue: _category,
                  items: ['バイク', '自転車', 'その他']
                      .map((category) => DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  ))
                      .toList(),
                  isEditing: _isEditing,
                  onChanged: (value) {
                    setState(() {
                      _category = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                CustomTextInput(
                  controller: _descriptionController,
                  label: '説明',
                  isEditing: _isEditing,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                CustomDropdown(
                  label: 'ステータス',
                  selectedValue: _status,
                  items: [
                    DropdownMenuItem(value: 'available', child: Text('販売中')),
                    DropdownMenuItem(value: 'sold', child: Text('売り切れ')),
                  ],
                  isEditing: _isEditing,
                  onChanged: (value) {
                    setState(() {
                      _status = value!;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
