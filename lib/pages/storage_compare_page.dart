import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class StorageComparePage extends StatefulWidget {
  const StorageComparePage({super.key});

  @override
  State<StorageComparePage> createState() => _StorageComparePageState();
}

class _StorageComparePageState extends State<StorageComparePage> {
  String spResult = "";
  String fileResult = "";

  /// SharedPreferences 저장 & 불러오기
  Future<void> testSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // 값 저장
    await prefs.setString("username", "홍길동");

    // 값 불러오기
    final name = prefs.getString("username") ?? "저장된 값 없음";
    setState(() {
      spResult = "저장된 사용자명: $name";
    });
  }

  /// path_provider를 이용한 파일 저장 & 불러오기
  Future<void> testPathProvider() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/test.txt");

    // 파일 쓰기
    await file.writeAsString("안녕하세요, path_provider 테스트입니다.");

    // 파일 읽기
    final contents = await file.readAsString();
    setState(() {
      fileResult = "파일 내용: $contents\n경로: ${file.path}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("로컬 저장소 비교")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("🔵 SharedPreferences"),
          ElevatedButton(
            onPressed: testSharedPreferences,
            child: const Text("SharedPreferences 테스트"),
          ),
          Text(spResult),

          const Divider(height: 32),

          const Text("🟢 path_provider"),
          ElevatedButton(
            onPressed: testPathProvider,
            child: const Text("파일 저장/읽기 테스트"),
          ),
          Text(fileResult),
        ],
      ),
    );
  }
}
