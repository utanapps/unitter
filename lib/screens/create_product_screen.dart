import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart'; // ImagePickerをインポート
import '../components/custom_snack_bar.dart';
import '../components/local_image_carousel.dart';
import '../components/custom_text_input.dart'; // CustomTextInputをインポート
import '../generated/l10n.dart';
import '../providers/supabase_provider.dart';
import '../services/supabase_service.dart';

class CreateProductScreen extends ConsumerStatefulWidget {
  const CreateProductScreen({Key? key}) : super(key: key);

  @override
  _CreateProductScreenState createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends ConsumerState<CreateProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  String _category = 'その他';
  List<Uint8List> _imagesData = [];
  List<String> _imageFileNames = [];

  Future<void> _pickImages(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      List<Uint8List> imagesData = [];
      List<String> fileNames = [];

      for (var pickedFile in pickedFiles) {
        final imageData = await pickedFile.readAsBytes();
        imagesData.add(imageData);
        fileNames.add(pickedFile.name);
      }

      setState(() {
        _imagesData = imagesData;
        _imageFileNames = fileNames;
      });
    }
  }

  Future<void> _createProduct(SupabaseService supabaseService, String userId) async {
    if (!_formKey.currentState!.validate()) {
      // バリデーションが失敗した場合は処理を中断
      return;
    }

    List<String> imageUrls = [];
    if (_imagesData.isNotEmpty && _imageFileNames.isNotEmpty) {
      for (int i = 0; i < _imagesData.length; i++) {
        String? imageUrl = await supabaseService.uploadImage(
          bucketName: 'market',
          userId: userId,
          imageData: _imagesData[i],
          fileName: _imageFileNames[i],
        );

        if (imageUrl == null) {
          CustomSnackBar.show(
            ScaffoldMessenger.of(context),
            S.of(context).imageUploadFailedMessage,
          );
          return;
        }

        imageUrls.add(imageUrl);
      }
    }

    try {
      final productResponse = await supabaseService.client.from('marketplace_posts').insert({
        'user_id': userId,
        'title': _nameController.text,
        'description': _descriptionController.text,
        'price': double.parse(_priceController.text),
        'category': _category,
        'image_url': imageUrls.isNotEmpty ? imageUrls[0] : null,
      }).select('id').single();

      final postId = productResponse['id'] as String;

      for (String imageUrl in imageUrls) {
        await supabaseService.client.from('marketplace_post_images').insert({
          'post_id': postId,
          'image_url': imageUrl,
        });
      }

      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).productCreationSuccessMessage,
      );
      Navigator.pop(context, true);
    } catch (e) {
      print('商品作成エラー: $e');
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).productCreationFailureMessage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final supabaseService = ref.read(supabaseServiceProvider);
    final userId = supabaseService.getCurrentUser()?.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).createProductTitle),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, // フォームのキー
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    _imagesData.isNotEmpty
                        ? LocalImageCarousel(
                      imagesData: _imagesData,
                      isEditing: true,
                      onDeleteImage: (index) {
                        setState(() {
                          _imagesData.removeAt(index);
                          _imageFileNames.removeAt(index);
                        });
                      },
                    )
                        : Image.asset(
                      'assets/images/gray.png',
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.8),
                        child: IconButton(
                          icon: Icon(Icons.camera_alt, color: Colors.blue),
                          onPressed: () => _pickImages(context),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                CustomTextInput(
                  controller: _nameController,
                  label: S.of(context).productNameLabel,
                  isEditing: true,
                ),
                SizedBox(height: 16),
                CustomTextInput(
                  controller: _descriptionController,
                  label: S.of(context).productDescriptionLabel,
                  isEditing: true,
                  maxLines: 3, // descriptionフィールドの高さを3行分に設定
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: S.of(context).productPriceLabel,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).priceRequiredMessage;
                    }
                    if (double.tryParse(value) == null) {
                      return S.of(context).invalidPriceMessage;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                DropdownButton<String>(
                  value: _category,
                  hint: Text(S.of(context).selectCategoryLabel),
                  items: ['バイク', '自転車', 'その他'].map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (category) {
                    setState(() {
                      _category = category!;
                    });
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (userId != null) {
                      _createProduct(supabaseService, userId);
                    } else {
                      CustomSnackBar.show(
                        ScaffoldMessenger.of(context),
                        S.of(context).userNotLoggedInMessage,
                      );
                    }
                  },
                  child: Text(S.of(context).createProductButtonText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
