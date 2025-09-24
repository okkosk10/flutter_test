import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MiscComparePage extends StatefulWidget {
  const MiscComparePage({super.key});

  @override
  State<MiscComparePage> createState() => _MiscComparePageState();
}

class _MiscComparePageState extends State<MiscComparePage> {
  String _status = "대기 중...";
  late FlutterLocalNotificationsPlugin _notifications;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();

    // flutter_local_notifications 초기화
    _notifications = FlutterLocalNotificationsPlugin();
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    _notifications.initialize(initSettings);
  }

  /// 2.11.1 flutter_local_notifications
  Future<void> _showNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'test_channel',
      '테스트 채널',
      importance: Importance.max,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    await _notifications.show(
      0,
      '테스트 알림',
      '로컬 알림이 도착했습니다!',
      details,
    );

    setState(() {
      _status = "📢 로컬 알림 표시됨";
    });
  }

  /// 2.11.2 webview_flutter
  void _openWebView() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const WebViewExample(),
      ),
    );
  }

  /// 2.11.3 flutter_launcher_icons
  void _showLauncherIconInfo() {
    setState(() {
      _status = "🚀 flutter_launcher_icons는 코드 실행이 아니라 "
          "pubspec.yaml 설정 후\n"
          "`flutter pub run flutter_launcher_icons` 명령으로 적용됩니다.";
    });
  }

  /// 2.11.4 smooth_page_indicator
  Widget _buildPageIndicatorDemo() {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            children: const [
              ColoredBox(color: Colors.red),
              ColoredBox(color: Colors.green),
              ColoredBox(color: Colors.blue),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SmoothPageIndicator(
          controller: _pageController,
          count: 3,
          effect: const WormEffect(dotHeight: 12, dotWidth: 12),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("2.11 기타 패키지 비교")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _showNotification,
                  child: const Text("1) 로컬 알림"),
                ),
                ElevatedButton(
                  onPressed: _openWebView,
                  child: const Text("2) WebView 열기"),
                ),
                ElevatedButton(
                  onPressed: _showLauncherIconInfo,
                  child: const Text("3) 런처 아이콘 안내"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: _buildPageIndicatorDemo()),
                  const Divider(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        _status,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ✅ WebView 예시 페이지 (webview_flutter ^4.x)
class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    final PlatformWebViewControllerCreationParams params =
    const PlatformWebViewControllerCreationParams();

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("https://flutter.dev"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("WebView 예시")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
