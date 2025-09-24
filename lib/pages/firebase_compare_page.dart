import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseComparePage extends StatefulWidget {
  const FirebaseComparePage({super.key});

  @override
  State<FirebaseComparePage> createState() => _FirebaseComparePageState();
}

class _FirebaseComparePageState extends State<FirebaseComparePage> {
  String? _fcmToken;
  String _log = "";

  @override
  void initState() {
    super.initState();
    _initFirebase();
  }

  Future<void> _initFirebase() async {
    await Firebase.initializeApp();

    // ✅ FCM 토큰 가져오기
    try {
      final token = await FirebaseMessaging.instance.getToken();
      setState(() {
        _fcmToken = token;
      });
    } catch (e) {
      setState(() {
        _log = "❌ FCM 토큰 가져오기 실패: $e";
      });
    }
  }

  void _sendAnalyticsEvent() async {
    await FirebaseAnalytics.instance.logEvent(
      name: "test_event",
      parameters: {
        "clicked": "true", // ✅ 문자열
      },
    );
    setState(() {
      _log = "✅ Analytics 이벤트 전송 완료";
    });
  }

  void _forceCrash() {
    FirebaseCrashlytics.instance.crash();
  }

  void _subscribeTopic() async {
    await FirebaseMessaging.instance.subscribeToTopic("test_topic");
    setState(() {
      _log = "✅ test_topic 구독 완료";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firebase 패키지 비교")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 2.6.1 firebase_core
          Card(
            child: ListTile(
              title: const Text("🔥 firebase_core"),
              subtitle: const Text("Firebase SDK 초기화 (모든 서비스의 기반)"),
              trailing: const Icon(Icons.done, color: Colors.green),
            ),
          ),

          // 2.6.2 firebase_analytics
          Card(
            child: Column(
              children: [
                const Text("📊 firebase_analytics"),
                ElevatedButton(
                  onPressed: _sendAnalyticsEvent,
                  child: const Text("이벤트 전송"),
                ),
              ],
            ),
          ),

          // 2.6.3 firebase_crashlytics
          Card(
            child: Column(
              children: [
                const Text("💥 firebase_crashlytics"),
                ElevatedButton(
                  onPressed: _forceCrash,
                  child: const Text("강제 크래시 발생"),
                ),
              ],
            ),
          ),

          // 2.6.4 firebase_messaging
          Card(
            child: Column(
              children: [
                const Text("📩 firebase_messaging"),
                Text("FCM Token: ${_fcmToken ?? '로딩 중...'}"),
                ElevatedButton(
                  onPressed: _subscribeTopic,
                  child: const Text("test_topic 구독"),
                ),
              ],
            ),
          ),

          if (_log.isNotEmpty) ...[
            const Divider(),
            Text("Log: $_log"),
          ],
        ],
      ),
    );
  }
}
