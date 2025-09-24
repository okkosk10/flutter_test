import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'dart:convert';

class NetworkComparePage extends StatefulWidget {
  const NetworkComparePage({super.key});

  @override
  State<NetworkComparePage> createState() => _NetworkComparePageState();
}

class _NetworkComparePageState extends State<NetworkComparePage> {
  String httpResult = "";
  String dioResult = "";
  String parserResult = "";
  String mimeResult = "";
  String httpImageUrl = "";
  String dioImageUrl = "";

  /// http 패키지로 강아지 사진 요청
  Future<void> testHttp() async {
    final res = await http.get(Uri.parse("https://dog.ceo/api/breeds/image/random"));
    final data = jsonDecode(res.body);
    setState(() {
      httpResult = data.toString();
      httpImageUrl = data['message'] ?? "";
    });
  }

  /// dio 패키지로 강아지 사진 요청
  Future<void> testDio() async {
    final dio = Dio();
    final res = await dio.get("https://dog.ceo/api/breeds/image/random");
    setState(() {
      dioResult = res.data.toString();
      dioImageUrl = res.data['message'] ?? "";
    });
  }

  /// http_parser 테스트
  void testParser() {
    final type = MediaType.parse("application/json");
    setState(() {
      parserResult = "Parsed MIME: ${type.mimeType}";
    });
  }

  /// mime 테스트
  void testMime() {
    final type = lookupMimeType("example.png");
    setState(() {
      mimeResult = "example.png → ${type ?? "unknown"}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("네트워크/데이터 통신 비교")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("🔵 http"),
          ElevatedButton(onPressed: testHttp, child: const Text("http GET 요청")),
          Text(httpResult),
          if (httpImageUrl.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(httpImageUrl, height: 200),
            ),

          const Divider(height: 32),

          const Text("🟢 dio"),
          ElevatedButton(onPressed: testDio, child: const Text("dio GET 요청")),
          Text(dioResult),
          if (dioImageUrl.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(dioImageUrl, height: 200),
            ),

          const Divider(height: 32),

          const Text("🟠 http_parser"),
          ElevatedButton(onPressed: testParser, child: const Text("MediaType 파싱")),
          Text(parserResult),

          const Divider(height: 32),

          const Text("🟣 mime"),
          ElevatedButton(onPressed: testMime, child: const Text("확장자 → MIME 매핑")),
          Text(mimeResult),
        ],
      ),
    );
  }
}
