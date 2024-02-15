import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

void main() {
  runApp(MyApp());
}

class LinkPreviewController extends GetxController {
  var imageUrl = ''.obs;
  var description = ''.obs;

  Future<void> fetchLinkPreview(String url) async {
    try {
      // Add "https://" prefix if missing
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        url = 'https://' + url;
      }

      var response = await http.get(
        Uri.parse(url),
        // url : url 파싱.
        headers: {'Accept-Charset': 'utf-8'},
        // 1. 한글 깨짐 방지
      );
      if (response.statusCode == 200) {
        var document = parse(utf8.decode(response.bodyBytes));
        // 2. 한글 깨짐 방지
        var metaTags = document.getElementsByTagName('meta');

        String? foundImageUrl;
        String? foundDescription;

        for (var tag in metaTags) {
          var property = tag.attributes['property'];
          var content = tag.attributes['content'];

          if (property == 'og:image' && foundImageUrl == null) {
            foundImageUrl = content;
          } else if (property == 'og:description' && foundDescription == null) {
            foundDescription = content;
          }
        }

        if (foundImageUrl != null && foundDescription != null) {
          imageUrl.value = foundImageUrl;
          description.value = foundDescription;
        } else {
          throw Exception('Failed to fetch link preview data: Image or description not found');
        }
      } else {
        throw Exception('Failed to fetch link preview data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to fetch link preview data: $e');
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Link Preview',
      home: LinkPreviewPage(),
    );
  }
}

class LinkPreviewPage extends StatelessWidget {
  final LinkPreviewController linkPreviewController = Get.put(LinkPreviewController());

  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Link Preview'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: 'Enter URL',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  linkPreviewController.fetchLinkPreview(textController.text);
                } else {
                  Get.snackbar(
                    'Error',
                    'Please enter a URL',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              child: Text('Get Link Preview'),
            ),
            SizedBox(height: 20),
            Obx(() {
              final imageUrl = linkPreviewController.imageUrl.value;
              final description = linkPreviewController.description.value;

              if (imageUrl.isEmpty || description.isEmpty) {
                return SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    imageUrl,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 10),
                  Text(
                    description,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}