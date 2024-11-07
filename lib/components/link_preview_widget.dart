// import 'package:flutter/material.dart';
// import 'package:metadata_fetch/metadata_fetch.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class LinkPreviewWidget extends StatelessWidget {
//   final String url;
//
//   LinkPreviewWidget({required this.url});
//
//   Future<Map<String, String?>> fetchLinkMetadata() async {
//     var data = await MetadataFetch.extract(url);
//     bool isYouTube = url.contains("youtube.com") || url.contains("youtu.be");
//
//     return {
//       'title': data?.title,
//       'description': isYouTube ? null : data?.description,
//       'image': data?.image,
//     };
//   }
//
//   Future<void> _launchURL(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Map<String, String?>>(
//       future: fetchLinkMetadata(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return const Padding(
//             padding: EdgeInsets.symmetric(vertical: 8.0),
//             child: Text('プレビューを取得できませんでした'),
//           );
//         } else if (!snapshot.hasData) {
//           return Center(child: CircularProgressIndicator());
//         } else {
//           final metadata = snapshot.data!;
//           final imageProvider = metadata['image'] != null && metadata['image']!.isNotEmpty
//               ? NetworkImage(metadata['image']!)
//               : const AssetImage('assets/images/gray.png') as ImageProvider;
//
//           return Card(
//             elevation: 4,
//             margin: EdgeInsets.symmetric(vertical: 8.0),
//             child: InkWell(
//               onTap: () => _launchURL(url),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     FadeInImage(
//                       placeholder: const AssetImage('assets/images/gray.png'),
//                       image: imageProvider,
//                       fit: BoxFit.cover,
//                       height: 200,
//                       width: 350,
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       metadata['title'] ?? 'タイトルを取得中...',
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     if (metadata['description'] != null)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 5.0),
//                         child: Text(metadata['description']!),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }
//       },
//     );
//   }
// }
