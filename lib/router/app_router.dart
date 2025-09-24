import 'package:get/get.dart';
import '../pages/compare_page.dart';
import '../pages/network_compare_page.dart';
import '../pages/storage_compare_page.dart';
import '../pages/ui_compare_page.dart';
import '../pages/media_compare_page.dart';
import '../pages/firebase_compare_page.dart';
import '../pages/auth_compare_page.dart';
import '../pages/crypto_compare_page.dart';
import '../pages/platform_compare_page.dart';
import '../pages/utility_compare_page.dart';
import '../pages/misc_compare_page.dart';

class AppRouter {
  static final routes = [
    GetPage(name: '/compare', page: () => ComparePage()), // ✅ 필수
    GetPage(name: '/network', page: () => NetworkComparePage()),
    GetPage(name: '/storage', page: () => StorageComparePage()),
    GetPage(name: '/ui', page: () => const UiComparePage()),
    GetPage(name: '/media', page: () => const MediaComparePage()),
    GetPage(name: '/firebase', page: () => const FirebaseComparePage()),
    GetPage(name: '/auth', page: () => const AuthComparePage()),
    GetPage(name: '/crypto', page: () => const CryptoComparePage()),
    GetPage(name: '/platform', page: () => const PlatformComparePage()),
    GetPage(name: '/utility', page: () => const UtilityComparePage()),
    GetPage(name: '/misc', page: () => const MiscComparePage()),
  ];
}