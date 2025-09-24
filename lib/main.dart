import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'manager/app_manager.dart';
import 'router/app_router.dart';

void main() {
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
          // 앞으로 테스트 페이지 버튼을 여기에 추가
        ],
      ),
    );
  }
}
