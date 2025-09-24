import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:decimal/decimal.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:characters/characters.dart';

class UtilityComparePage extends StatefulWidget {
  const UtilityComparePage({super.key});

  @override
  State<UtilityComparePage> createState() => _UtilityComparePageState();
}

class _UtilityComparePageState extends State<UtilityComparePage> {
  String _result = "대기 중...";

  /// 2.10.1 intl
  void _testIntl() {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);
    final formattedNumber = NumberFormat('#,###.##').format(1234567.89);

    setState(() {
      _result = "📅 intl 예시\n"
          "날짜: $formattedDate\n"
          "숫자: $formattedNumber";
    });
  }

  /// 2.10.2 decimal
  void _testDecimal() {
    final a = Decimal.parse('0.1');
    final b = Decimal.parse('0.2');
    final sum = a + b;

    setState(() {
      _result = "➗ decimal 예시\n"
          "0.1 + 0.2 = $sum (정확한 계산)";
    });
  }

  /// 2.10.3 url_launcher
  Future<void> _testUrlLauncher() async {
    final Uri url = Uri.parse("https://flutter.dev");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
      setState(() => _result = "🌐 url_launcher 예시: 브라우저 열림");
    } else {
      setState(() => _result = "url_launcher 실패: 브라우저 실행 불가");
    }
  }

  /// 2.10.4 uuid
  void _testUuid() {
    final uuid = Uuid();
    final id = uuid.v4();

    setState(() {
      _result = "🔑 uuid 예시\n"
          "생성된 UUID: $id";
    });
  }

  /// 2.10.5 characters
  void _testCharacters() {
    final text = '👨‍👩‍👧‍👦안녕하세요';
    final length = text.characters.length;
    final sliced = text.characters.take(4).toString();

    setState(() {
      _result = "🔤 characters 예시\n"
          "문자열: $text\n"
          "글자 단위 length: $length\n"
          "앞 4글자: $sliced";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("2.10 유틸리티 비교")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _testIntl,
                  child: const Text("1) intl"),
                ),
                ElevatedButton(
                  onPressed: _testDecimal,
                  child: const Text("2) decimal"),
                ),
                ElevatedButton(
                  onPressed: _testUrlLauncher,
                  child: const Text("3) url_launcher"),
                ),
                ElevatedButton(
                  onPressed: _testUuid,
                  child: const Text("4) uuid"),
                ),
                ElevatedButton(
                  onPressed: _testCharacters,
                  child: const Text("5) characters"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _result,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
