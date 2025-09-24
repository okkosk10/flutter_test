import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'manager/app_manager.dart';
import 'router/app_router.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppManager()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sandbox App',
      home: const HomePage(),              // ✅ 초기화 안전하게
      getPages: [
        GetPage(name: '/', page: () => const HomePage()),
        ...AppRouter.routes,
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("샌드박스 홈")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton(
            onPressed: () => Get.toNamed('/compare'),
            child: const Text("Provider vs GetX 비교"),
          ),
          ElevatedButton(
            onPressed: () => Get.toNamed('/network'),
            child: const Text("네트워크/데이터 통신 비교"),
          ),
          ElevatedButton(
            onPressed: () => Get.toNamed('/storage'),
            child: const Text("로컬 저장소 비교"),
          ),
          ElevatedButton(
            onPressed: () => Get.toNamed('/ui'),
            child: const Text("UI/UX 컴포넌트 비교"),
          ),
          ElevatedButton(
            onPressed: () => Get.toNamed('/media'),
            child: const Text("Media 패키지 비교"),
          ),
          ElevatedButton(
            onPressed: () => Get.toNamed('/firebase'),
            child: const Text("Firebase 패키지 비교"),
          ),
        ],
      ),
    );
  }
}
