import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/custom_snack_bar.dart';
import '../components/image_picker_widget.dart';
import '../generated/l10n.dart';
import '../providers/supabase_provider.dart';
import '../services/supabase_service.dart';

class CreateChannelScreen extends ConsumerStatefulWidget {
  const CreateChannelScreen({Key? key}) : super(key: key);

  @override
  _CreateChannelScreenState createState() => _CreateChannelScreenState();
}

class _CreateChannelScreenState extends ConsumerState<CreateChannelScreen> {
  final TextEditingController channelController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  Uint8List? selectedImageData;
  String? selectedFileName;
  String? selectedCategoryId;
  String? selectedPrefectureName;
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> prefectures = [];
  bool isLoadingCategories = true;
  bool isLoadingPrefectures = true;
  bool isCreatingChannel = false;
  late final SupabaseService supabaseService;

  @override
  void initState() {
    super.initState();
    supabaseService = ref.read(supabaseServiceProvider);
    fetchCategories();
    fetchPrefectures();
  }

  Future<void> fetchCategories() async {
    const serverId = 'eac617e7-494c-4b72-b7fc-7c59f33fb7cc';
    try {
      final response = await supabaseService.client
          .from('categories')
          .select()
          .eq('server_id', serverId);
      if (mounted) {
        setState(() {
          categories = List<Map<String, dynamic>>.from(response);
          isLoadingCategories = false;
        });
      }
    } catch (e) {
      _showErrorSnackBar(S.of(context).error);
      setState(() => isLoadingCategories = false);
    }
  }

  Future<void> fetchPrefectures() async {
    try {
      final response = await supabaseService.client.from('prefectures').select();
      if (mounted) {
        setState(() {
          prefectures = List<Map<String, dynamic>>.from(response);
          isLoadingPrefectures = false;
        });
      }
    } catch (e) {
      _showErrorSnackBar(S.of(context).prefectureFetchError);
      setState(() => isLoadingPrefectures = false);
    }
  }

  Future<void> createChannel() async {
    if (!_validateInputs()) return;

    setState(() => isCreatingChannel = true);
    try {
      const serverId = 'eac617e7-494c-4b72-b7fc-7c59f33fb7cc';
      final userId = supabaseService.getCurrentUser()?.id;
      String? imageUrl;

      if (selectedImageData != null && selectedFileName != null) {
        imageUrl = await supabaseService.uploadImage(
          bucketName: 'chat',
          userId: userId!,
          imageData: selectedImageData!,
          fileName: selectedFileName!,
        );
      }

      await supabaseService.client.from('channels').insert({
        'server_id': serverId,
        'name': channelController.text,
        'description': descriptionController.text,
        'type': 'text',
        'category_id': selectedCategoryId,
        'avatar_url': imageUrl,
        'country': 'Japan',
        'prefecture': selectedPrefectureName,
        'owner_id': userId,
        'created_at': DateTime.now().toIso8601String(),
      });

      _showSuccessSnackBar(S.of(context).channelCreationSuccessMessage);
      Navigator.of(context).pop(true);
    } catch (e) {
      _showErrorSnackBar(S.of(context).channelCreationFailureMessage);
    } finally {
      setState(() => isCreatingChannel = false);
    }
  }

  bool _validateInputs() {
    if (selectedCategoryId == null) {
      _showErrorSnackBar(S.of(context).categoryNotSelectedMessage);
      return false;
    }
    if (selectedPrefectureName == null) {
      _showErrorSnackBar(S.of(context).prefectureNotSelectedMessage);
      return false;
    }
    return true;
  }

  void _showErrorSnackBar(String message) {
    CustomSnackBar.show(ScaffoldMessenger.of(context), message);
  }

  void _showSuccessSnackBar(String message) {
    CustomSnackBar.show(ScaffoldMessenger.of(context), message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).channelCreationTitle),
        actions: [
          IconButton(
            icon: isCreatingChannel
                ? const CircularProgressIndicator()
                : const Icon(Icons.check),
            onPressed: isCreatingChannel ? null : () => createChannel(),
          ),
        ],
      ),
      body: isLoadingCategories || isLoadingPrefectures
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildImagePickerSection(),
            const SizedBox(height: 16),
            _buildTextInputSection(),
            const SizedBox(height: 16),
            _buildDropdownSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                height: 200,
                alignment: Alignment.center,
                child: selectedImageData != null
                    ? Image.memory(selectedImageData!, width: 200, height: 200, fit: BoxFit.cover)
                    : Image.asset('assets/images/default_avatar2.png', width: 200, height: 200, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 8),
            ImagePickerWidget(
              onImageSelected: (Uint8List imageData, String fileName) {
                setState(() {
                  selectedImageData = imageData;
                  selectedFileName = fileName;
                });
              },
              buttonText: S.of(context).selectImageButtonText,
              purpose: 'chat',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextInputSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: channelController,
              decoration: InputDecoration(
                hintText: S.of(context).channelNameLabel,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: S.of(context).channelDescriptionLabel,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdown(
              labelText: S.of(context).selectCategoryLabel,
              value: selectedCategoryId,
              items: categories.map((category) => DropdownMenuItem<String>(
                value: category['id'].toString(),
                child: Text(category['name'] as String),
              )).toList(),
              onChanged: (value) {
                setState(() => selectedCategoryId = value);
              },
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              labelText: S.of(context).selectPrefectureLabel,
              value: selectedPrefectureName,
              items: prefectures.map((prefecture) => DropdownMenuItem<String>(
                value: prefecture['name'] as String,
                child: Text(prefecture['name'] as String),
              )).toList(),
              onChanged: (value) {
                setState(() => selectedPrefectureName = value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String labelText,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  void dispose() {
    channelController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
