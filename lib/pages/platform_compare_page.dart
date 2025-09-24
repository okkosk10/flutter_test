import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:advertising_id/advertising_id.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:restart_app/restart_app.dart';

class PlatformComparePage extends StatefulWidget {
  const PlatformComparePage({super.key});

  @override
  State<PlatformComparePage> createState() => _PlatformComparePageState();
}

class _PlatformComparePageState extends State<PlatformComparePage> {
  String _status = "대기 중...";
  final KeyboardVisibilityController _keyboardController =
  KeyboardVisibilityController();

  @override
  void initState() {
    super.initState();

    // 키보드 상태 리스너
    _keyboardController.onChange.listen((visible) {
      setState(() {
        _status = visible ? "키보드 열림 감지" : "키보드 닫힘 감지";
      });
    });
  }

  /// 2.9.1 permission_handler
  Future<void> _checkCameraPermission() async {
    var status = await Permission.camera.request();
    setState(() {
      _status = "카메라 권한: $status";
    });
  }

  /// 2.9.2 connectivity_plus
  Future<void> _checkConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    setState(() {
      _status = "네트워크 상태: $result";
    });
  }

  /// 2.9.3 device_info_plus
  Future<void> _getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    final info = await deviceInfo.deviceInfo;
    setState(() {
      _status = "디바이스 정보: ${info.data}";
    });
  }

  /// 2.9.4 package_info_plus
  Future<void> _getPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _status = "앱 정보: ${info.appName}, v${info.version} (${info.buildNumber})";
    });
  }

  /// 2.9.5 advertising_id
  Future<void> _getAdId() async {
    try {
      final adId = await AdvertisingId.id(true);
      setState(() {
        _status = "광고 ID: $adId";
      });
    } catch (e) {
      setState(() {
        _status = "광고 ID 조회 실패: $e";
      });
    }
  }

  /// 2.9.7 restart_app
  void _restartApp() {
    Restart.restartApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("2.9 플랫폼/네이티브 연동 비교")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _checkCameraPermission,
                  child: const Text("1) 권한 확인"),
                ),
                ElevatedButton(
                  onPressed: _checkConnectivity,
                  child: const Text("2) 네트워크 상태"),
                ),
                ElevatedButton(
                  onPressed: _getDeviceInfo,
                  child: const Text("3) 디바이스 정보"),
                ),
                ElevatedButton(
                  onPressed: _getPackageInfo,
                  child: const Text("4) 앱 정보"),
                ),
                ElevatedButton(
                  onPressed: _getAdId,
                  child: const Text("5) 광고 ID"),
                ),
                ElevatedButton(
                  onPressed: _restartApp,
                  child: const Text("7) 앱 재시작"),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
    );
  }
}
