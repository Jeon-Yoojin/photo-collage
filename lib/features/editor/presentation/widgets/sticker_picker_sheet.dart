import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class StickerPickerSheet extends StatefulWidget {
  final void Function(String imgPath) onStickerSelected;

  const StickerPickerSheet({super.key, required this.onStickerSelected});

  @override
  State<StickerPickerSheet> createState() => _StickerPickerSheetState();
}

class _StickerPickerSheetState extends State<StickerPickerSheet> {
  List<String> imgPathList = [];
  String pos = "";

  Future<void> _loadMore() async {
    final newItems = await _fetchMoreStickers('cat');
    setState(() {
      imgPathList.addAll(newItems);
    });
  }

  Future<List<String>> _fetchMoreStickers(String query) async {
    final url = Uri.https(
      "tenor.googleapis.com",
      "/v2/search",
      {
        'key': dotenv.env['TENOR_API_KEY']!,
        'q': query,
        'client_key': dotenv.env['TENOR_CLIENT_KEY']!,
        'searchfilter': "sticker,static",
        // country: "KR",
        'limit': "10",
        'pos': pos != "" ? pos : null,
      },
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List;
        setState(() {
          pos = data['next'] != null ? data['next'] as String : "";
        });
        return results.map((item) {
          final mediaFormats = item['media_formats'] as Map<String, dynamic>;

          // webp / gif / nanogifpreview 중 하나 반환
          if (mediaFormats['webp'] != null) {
            return mediaFormats['webp']['url'] as String;
          } else if (mediaFormats['gif'] != null) {
            return mediaFormats['gif']['url'] as String;
          } else {
            return mediaFormats['nanogifpreview']['url'] as String;
          }
        }).toList();
      } else {
        throw Exception('sticker 가져오기 실패, statusCode: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('sticker 가져오기 실패: ${error.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: imgPathList.length + 1,
              itemBuilder: (context, index) {
                if (index == imgPathList.length) {
                  if (imgPathList.isEmpty || pos != "") {
                    _loadMore();
                    return Container(
                      padding: EdgeInsets.all(16),
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                }

                final imgPath = imgPathList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    widget.onStickerSelected(imgPath);
                  },
                  child: Image(
                    image: NetworkImage(imgPath),
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
