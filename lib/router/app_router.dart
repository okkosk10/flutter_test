import 'package:get/get.dart';
import '../pages/compare_page.dart';

class AppRouter {
  static final routes = [
    GetPage(name: '/compare', page: () => ComparePage()), // ✅ 필수
  ];
}