import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animations/animations.dart';

class UiComparePage extends StatefulWidget {
  const UiComparePage({super.key});

  @override
  State<UiComparePage> createState() => _UiComparePageState();
}

class _UiComparePageState extends State<UiComparePage> {
  final PageController _pageController = PageController();

  bool _isVisible = false;
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("UI/UX 위젯 비교")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 2.4.1 Cupertino Icons
          Card(
            child: ListTile(
              leading: const Icon(CupertinoIcons.heart, color: Colors.red),
              title: const Text("Cupertino Icons (iOS 스타일 아이콘)"),
            ),
          ),

          // 2.4.2 flutter_spinkit
          Card(
            child: Column(
              children: const [
                Text("flutter_spinkit (로딩 애니메이션)"),
                SpinKitFadingCircle(color: Colors.blue, size: 40),
              ],
            ),
          ),

          // 2.4.3 cached_network_image
          Card(
            child: Column(
              children: [
                const Text("cached_network_image (이미지 캐싱)"),
                CachedNetworkImage(
                  imageUrl: "https://picsum.photos/200",
                  placeholder: (c, s) => const CircularProgressIndicator(),
                  errorWidget: (c, s, e) => const Icon(Icons.error),
                ),
              ],
            ),
          ),

          // 2.4.4 photo_view
          SizedBox(
            height: 200,
            child: Card(
              child: PhotoView(
                backgroundDecoration: const BoxDecoration(color: Colors.white),
                imageProvider: const NetworkImage("https://picsum.photos/400"),
              ),
            ),
          ),

          // 2.4.5 smooth_page_indicator
          Card(
            child: Column(
              children: [
                const Text("smooth_page_indicator (페이지 인디케이터)"),
                SizedBox(
                  height: 150,
                  child: PageView(
                    controller: _pageController,
                    children: List.generate(
                      3,
                          (i) => Container(
                        color: Colors.primaries[i],
                        child: Center(child: Text("Page $i")),
                      ),
                    ),
                  ),
                ),
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: const WormEffect(),
                ),
              ],
            ),
          ),

          // 2.4.6 auto_size_text
          Card(
            child: Column(
              children: const [
                Text("auto_size_text (자동 크기 조절)"),
                SizedBox(
                  width: 100,
                  child: AutoSizeText(
                    "이 텍스트는 너무 길어도 자동으로 줄어듭니다!",
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),

          // 2.4.7 visibility_detector
          Card(
            child: Column(
              children: [
                const Text("visibility_detector (보임 감지)"),
                VisibilityDetector(
                  key: const Key("visibleBox"),
                  onVisibilityChanged: (info) {
                    setState(() {
                      _isVisible = info.visibleFraction > 0;
                    });
                  },
                  child: Container(
                    height: 100,
                    color: Colors.orange,
                    child: Center(
                      child: Text(_isVisible ? "보이는 중 👀" : "숨겨짐"),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2.4.8 font_awesome_flutter
          Card(
            child: Column(
              children: const [
                Text("font_awesome_flutter (아이콘)"),
                FaIcon(FontAwesomeIcons.github, size: 40),
              ],
            ),
          ),

          // 2.4.9 animations
          Card(
            child: Column(
              children: [
                const Text("animations (Material Motion)"),
                PageTransitionSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, anim, secAnim) =>
                      FadeThroughTransition(
                        animation: anim,
                        secondaryAnimation: secAnim,
                        child: child,
                      ),
                  child: Container(
                    key: ValueKey<int>(_currentPage),
                    color: _currentPage.isEven ? Colors.blue : Colors.green,
                    height: 100,
                    child: Center(child: Text("Page $_currentPage")),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentPage++;
                    });
                  },
                  child: const Text("애니메이션 전환"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
