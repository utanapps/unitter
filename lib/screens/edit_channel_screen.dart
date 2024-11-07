import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unitter/services/supabase_service.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import '../components/custom_snack_bar.dart';
import '../generated/l10n.dart';
import '../providers/supabase_provider.dart';

class EditChannelScreen extends ConsumerStatefulWidget {
  final String channelId;

  const EditChannelScreen({Key? key, required this.channelId}) : super(key: key);

  @override
  _EditChannelScreenState createState() => _EditChannelScreenState();
}

class _EditChannelScreenState extends ConsumerState<EditChannelScreen> {
  final TextEditingController channelController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  Uint8List? selectedImageData;
  String? selectedFileName;
  String? selectedCategoryId;
  String? selectedPrefectureName;
  String? avatarUrl;

  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> prefectures = [];
  bool isLoadingCategories = true;
  bool isLoadingPrefectures = true;
  bool isLoadingChannel = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchPrefectures();
    fetchChannelDetails();
  }

  Future<void> fetchChannelDetails() async {
    try {
      final supabaseService = ref.read(supabaseServiceProvider);
      final response = await supabaseService.client
          .from('channels')
          .select()
          .eq('id', widget.channelId)
          .single();

      setState(() {
        channelController.text = response['name'];
        descriptionController.text = response['description'] ?? '';
        selectedCategoryId = response['category_id'].toString();
        selectedPrefectureName = response['prefecture'];
        avatarUrl = response['avatar_url'];
        isLoadingChannel = false;
      });
    } catch (e) {
      print(S.of(context).channelFetchFailureMessage + ': $e');
      setState(() {
        isLoadingChannel = false;
      });
    }
  }

  Future<void> fetchCategories() async {
    try {
      final supabaseService = ref.read(supabaseServiceProvider);
      const serverId = 'eac617e7-494c-4b72-b7fc-7c59f33fb7cc';

      final response = await supabaseService.client
          .from('categories')
          .select()
          .eq('server_id', serverId);

      setState(() {
        categories = List<Map<String, dynamic>>.from(response);
        isLoadingCategories = false;
      });
    } catch (e) {
      print(S.of(context).categoryFetchFailureMessage + ': $e');
      setState(() {
        isLoadingCategories = false;
      });
    }
  }

  Future<void> fetchPrefectures() async {
    try {
      final supabaseService = ref.read(supabaseServiceProvider);
      final response = await supabaseService.client.from('prefectures').select();

      setState(() {
        prefectures = List<Map<String, dynamic>>.from(response);
        isLoadingPrefectures = false;
      });
    } catch (e) {
      print(S.of(context).prefectureFetchFailureMessage + ': $e');
      setState(() {
        isLoadingPrefectures = false;
      });
    }
  }

  Future<void> _selectImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      Uint8List imageData = await image.readAsBytes();
      String fileName = image.name;

      setState(() {
        selectedImageData = imageData;
        selectedFileName = fileName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final supabaseService = ref.read(supabaseServiceProvider);
    final userId = supabaseService.getCurrentUser()?.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).editChannelTitle),
      ),
      body: isLoadingCategories || isLoadingPrefectures || isLoadingChannel
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 100,
                    backgroundImage: selectedImageData != null
                        ? MemoryImage(selectedImageData!)
                        : avatarUrl != null && avatarUrl!.isNotEmpty
                        ? NetworkImage(avatarUrl!)
                        : const AssetImage('assets/images/default_avatar2.png') as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        _selectImage();
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade800,
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: channelController,
                decoration: InputDecoration(
                  labelText: S.of(context).channelNameInputLabel,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: S.of(context).channelDescriptionInputLabel,
                ),
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                value: selectedCategoryId,
                items: categories
                    .map((category) => DropdownMenuItem<String>(
                  value: category['id'].toString(),
                  child: Text(category['name'] as String),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategoryId = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: S.of(context).selectCategoryLabel,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                value: selectedPrefectureName,
                items: prefectures
                    .map((prefecture) => DropdownMenuItem<String>(
                  value: prefecture['name'] as String,
                  child: Text(prefecture['name'] as String),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPrefectureName = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: S.of(context).selectPrefectureLabel,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                updateChannel(
                  context,
                  channelController.text,
                  descriptionController.text,
                  supabaseService,
                  selectedCategoryId,
                  selectedPrefectureName,
                  selectedImageData,
                  selectedFileName,
                  userId!,
                );
              },
              child: Text(S.of(context).updateChannelButtonLabel),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                deleteChannel(context, supabaseService, userId!);
              },
              child: Text(S.of(context).deleteChannelButtonLabel),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateChannel(
      BuildContext context,
      String channelName,
      String description,
      SupabaseService supabaseService,
      String? categoryId,
      String? prefectureName,
      Uint8List? imageData,
      String? fileName,
      String userId,
      ) async {
    if (categoryId == null) {
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).categoryNotSelectedMessage,
      );
      return;
    }

    if (prefectureName == null) {
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).prefectureNotSelectedMessage,
      );
      return;
    }

    try {
      String? imageUrl;
      if (imageData != null && fileName != null) {
        imageUrl = await supabaseService.uploadImage(
          bucketName: 'chat',
          userId: userId,
          imageData: imageData,
          fileName: fileName,
        );
      }

      await supabaseService.client.from('channels').update({
        'name': channelName,
        'description': description,
        'category_id': categoryId,
        'prefecture': prefectureName,
        'avatar_url': imageUrl ?? avatarUrl,
      }).eq('id', widget.channelId);

      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).channelUpdateSuccessMessage,
      );
      Navigator.of(context).pop(true);
    } catch (error) {
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).channelUpdateFailureMessage,
      );
    }
  }

  Future<void> deleteChannel(
      BuildContext context,
      SupabaseService supabaseService,
      String userId,
      ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).channelDeleteTitle),
          content: Text(S.of(context).channelDeleteConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(S.of(context).cancelLabel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(S.of(context).deleteLabel, style: const TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      await supabaseService.client
          .from('channels')
          .delete()
          .eq('id', widget.channelId)
          .eq('owner_id', userId);

      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).channelDeleteSuccessMessage,
      );
      Navigator.of(context).pop();
    } catch (error) {
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).channelDeleteFailureMessage,
      );
    }
  }

  @override
  void dispose() {
    channelController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
