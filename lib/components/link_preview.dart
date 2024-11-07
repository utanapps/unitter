import 'package:flutter/material.dart';
import 'package:unitter/utils/link_utils.dart';
import '../generated/l10n.dart';

class LinkPreview extends StatelessWidget {
  final String url;

  const LinkPreview({Key? key, required this.url}) : super(key: key);

  String _truncateTitle(String text) {
    if (text.length > 50) {
      return text.substring(0, 50) + '...';
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String?>>(
      future: fetchLinkMetadata(url),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(S.of(context).linkPreviewError), // エラーメッセージを多言語対応
          );
        }

        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: CircularProgressIndicator(),
          );
        }

        final metadata = snapshot.data!;
        return _linkPreviewWidget(context, metadata);
      },
    );
  }

  Widget _linkPreviewWidget(
      BuildContext context, Map<String, String?> metadata) {
    final imageProvider =
    metadata['image'] != null && metadata['image']!.isNotEmpty
        ? NetworkImage(metadata['image']!)
        : const AssetImage('assets/images/gray.png') as ImageProvider;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => launchURL(context, url),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/images/gray.png'),
                  image: imageProvider,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _truncateTitle(metadata['title'] ?? S.of(context).fetchingTitleMessage),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
