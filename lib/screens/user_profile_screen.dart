import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../generated/l10n.dart';
import 'package:unitter/services/supabase_service.dart';
import '../components/image_picker_widget.dart';
import '../providers/supabase_provider.dart';
import '../components/custom_snack_bar.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  Uint8List? _imageData;
  String? _imageFileName;
  String? _imageUrl;
  String? _bio;
  final TextEditingController _bioController = TextEditingController();
  bool _isLoading = true;
  bool _isBioEdited = false;

  Future<void> _fetchUserProfile(SupabaseService supabaseService, String userId) async {
    try {
      final profile = await supabaseService.getUserProfile(userId);
      setState(() {
        _imageUrl = profile['avatar_url'];
        _bio = profile['bio'];
        _bioController.text = _bio ?? '';
        _isLoading = false;
      });
    } catch (e) {
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).profileFetchError,
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _uploadImage(String userId, SupabaseService supabaseService) async {
    if (_imageData == null || _imageFileName == null) return;

    final imageUrl = await supabaseService.uploadImage(
      bucketName: 'profiles',
      userId: userId,
      imageData: _imageData!,
      fileName: _imageFileName!,
    );

    if (imageUrl == null) {
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).imageUploadError,
      );
      return;
    }

    setState(() {
      _imageUrl = imageUrl;
    });

    await supabaseService.client.from('profiles').update({
      'avatar_url': imageUrl,
    }).eq('id', userId);

    CustomSnackBar.show(
      ScaffoldMessenger.of(context),
      S.of(context).imageUploadSuccess,
    );
  }

  Future<void> _updateBio(String userId, SupabaseService supabaseService) async {
    try {
      await supabaseService.client.from('profiles').update({
        'bio': _bioController.text,
      }).eq('id', userId);

      setState(() {
        _isBioEdited = false;
      });

      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).bioUpdateSuccess,
      );
    } catch (e) {
      CustomSnackBar.show(
        ScaffoldMessenger.of(context),
        S.of(context).bioUpdateError,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final supabaseService = ref.read(supabaseServiceProvider);
    final userId = supabaseService.getCurrentUser()?.id;

    if (userId != null) {
      _fetchUserProfile(supabaseService, userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final supabaseService = ref.read(supabaseServiceProvider);
    final userId = supabaseService.getCurrentUser()?.id;

    return Scaffold(
      appBar: AppBar(),
      resizeToAvoidBottomInset: true,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundImage: _imageData != null
                      ? MemoryImage(_imageData!)
                      : (_imageUrl != null && _imageUrl!.isNotEmpty
                      ? NetworkImage(_imageUrl!)
                      : AssetImage('assets/images/default_avatar.png')) as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: ImagePickerWidget(
                    onImageSelected: (Uint8List imageData, String fileName) {
                      setState(() {
                        _imageData = imageData;
                        _imageFileName = fileName;
                      });
                    },
                    initialImageUrl: _imageUrl,
                    customButton: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff06DD76),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.camera_alt, color: Colors.black87),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _bioController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: S.of(context).aboutMe,
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
              ),
              onChanged: (text) {
                setState(() {
                  _isBioEdited = true;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff06DD76),
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              ),
              onPressed: () async {
                if (userId != null) {
                  if (_imageData != null) {
                    await _uploadImage(userId, supabaseService);
                  }
                  if (_isBioEdited) {
                    await _updateBio(userId, supabaseService);
                  }
                } else {
                  CustomSnackBar.show(
                    ScaffoldMessenger.of(context),
                    S.of(context).userNotLoggedIn,
                  );
                }
              },
              child: Text(S.of(context).save, style: TextStyle(color: Colors.black87)),
            ),
          ],
        ),
      ),
    );
  }
}
