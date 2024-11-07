import 'package:flutter/material.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

/// URLを開く共通関数
Future<void> launchURL(BuildContext context, String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not launch $url')),
    );
  }
}

/// 自動リダイレクトを防ぐHTTP GET関数
Future<http.StreamedResponse> httpGetWithoutAutoRedirect(Uri uri) async {
  var req = http.Request("GET", uri);
  req.followRedirects = false;
  req.headers["User-Agent"] = "bot";
  var baseClient = http.Client();
  return await baseClient.send(req);
}

/// メタデータを取得する関数（リダイレクト対応）
Future<Map<String, String?>> fetchLinkMetadata(String url) async {
  final data = await fetchMetaData(url);
  bool isYouTube = url.contains("youtube.com") || url.contains("youtu.be");

  return {
    'title': data?.title ?? 'タイトルを取得中...',
    'description': isYouTube ? null : data?.description,
    'image': data?.image,
  };
}

/// リダイレクト対応のメタデータ取得関数
Future<Metadata?> fetchMetaData(String url) async {
  var uri = Uri.parse(url);
  var streamedResponse = await httpGetWithoutAutoRedirect(uri);

  // 無限リダイレクトを防ぐため最大5回までリダイレクトを許可
  for (var i = 0; streamedResponse.isRedirect && i < 5; i++) {
    final redirectURL = streamedResponse.headers["location"];
    if (redirectURL == null) {
      debugPrint('リダイレクトURLの取得に失敗しました: $url');
      break;
    }
    uri = Uri.parse(redirectURL);
    streamedResponse = await httpGetWithoutAutoRedirect(uri);
  }

  final response = await http.Response.fromStream(streamedResponse);
  final document = MetadataFetch.responseToDocument(response);
  return MetadataParser.parse(document, url: url);
}

/// メッセージから最初に見つかったURLを抽出する関数
String? extractUrlFromMessage(String message) {
  final RegExp urlRegex = RegExp(
      r'((https?|ftp):\/\/[^\s/$.?#].[^\s]*)',
      caseSensitive: false);
  final match = urlRegex.firstMatch(message);
  return match?.group(0);
}
