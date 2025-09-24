import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:games_services/games_services.dart';

class AuthComparePage extends StatefulWidget {
  const AuthComparePage({super.key});

  @override
  State<AuthComparePage> createState() => _AuthComparePageState();
}

class _AuthComparePageState extends State<AuthComparePage> {
  String _status = "결과 대기 중...";

  Future<void> _googleLogin() async {
    try {
      final googleSignIn = GoogleSignIn();
      final account = await googleSignIn.signIn();
      setState(() {
        _status = account != null
            ? "구글 로그인 성공: ${account.displayName}"
            : "구글 로그인 취소됨";
      });
    } catch (e) {
      setState(() {
        _status = "구글 로그인 에러: $e";
      });
    }
  }

  Future<void> _appleLogin() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      setState(() {
        _status = "애플 로그인 성공: ${credential.email ?? "이메일 없음"}";
      });
    } catch (e) {
      setState(() {
        _status = "애플 로그인 에러: $e";
      });
    }
  }

  Future<void> _gameServices() async {
    try {
      await GamesServices.signIn();
      await GamesServices.unlock(
        achievement: Achievement(
          androidID: "achievement_test",
          iOSID: "achievement_test_ios",
        ),
      );
      setState(() {
        _status = "게임 서비스 로그인 및 업적 등록 성공!";
      });
    } catch (e) {
      setState(() {
        _status = "게임 서비스 에러: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("인증 & 플랫폼 연동 비교"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _googleLogin,
              child: const Text("구글 로그인"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _appleLogin,
              child: const Text("애플 로그인"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _gameServices,
              child: const Text("게임 서비스 연동"),
            ),
            const SizedBox(height: 20),
            Text(
              _status,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
