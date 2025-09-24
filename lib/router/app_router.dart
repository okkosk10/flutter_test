import 'package:get/get.dart';
import '../pages/compare_page.dart';
import '../pages/network_compare_page.dart';
import '../pages/storage_compare_page.dart';
import '../pages/ui_compare_page.dart';

class AppRouter {
  static final routes = [
    GetPage(name: '/compare', page: () => ComparePage()), // ✅ 필수
    GetPage(name: '/network', page: () => NetworkComparePage()),
    GetPage(name: '/storage', page: () => StorageComparePage()),
    GetPage(name: '/ui', page: () => const UiComparePage()),
  ];
}