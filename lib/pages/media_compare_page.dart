import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class MediaComparePage extends StatefulWidget {
  const MediaComparePage({super.key});

  @override
  State<MediaComparePage> createState() => _MediaComparePageState();
}

class _MediaComparePageState extends State<MediaComparePage> {
  // video_player
  VideoPlayerController? _videoController;
  bool _isVideoReady = false;

  // image_picker & image_cropper
  File? _pickedImage;
  bool _isLoading = false; // 다운로드/크롭 등 진행 상태

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    final controller = VideoPlayerController.networkUrl(
      Uri.parse("https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4"),
    );

    try {
      await controller.initialize();
      setState(() {
        _videoController = controller;
        _isVideoReady = true;
      });
    } catch (e) {
      debugPrint("❌ 비디오 초기화 실패: $e");
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  // 갤러리에서 이미지 선택
  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _pickedImage = File(pickedFile.path);
        });
      } else {
        debugPrint("⚠️ 이미지 선택 취소됨");
      }
    } catch (e) {
      debugPrint("❌ 이미지 선택 실패: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("이미지를 불러오는 중 오류 발생")),
        );
      }
    }
  }

  // 테스트용 네트워크 이미지 다운로드 → File 변환
  Future<void> _loadTestImage() async {
    setState(() => _isLoading = true);
    try {
      final response = await Dio().get(
        "https://picsum.photos/400",
        options: Options(responseType: ResponseType.bytes),
      );

      final tempDir = await getTemporaryDirectory();
      final file = File("${tempDir.path}/test.jpg");
      await file.writeAsBytes(response.data);

      setState(() {
        _pickedImage = file;
      });

      debugPrint("✅ 테스트 이미지 불러오기 성공: ${file.path}");
    } catch (e) {
      debugPrint("❌ 테스트 이미지 불러오기 실패: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("테스트 이미지를 불러오지 못했습니다.")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // 이미지 크롭
  Future<void> _cropImage() async {
    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("먼저 이미지를 선택하세요")),
      );
      return;
    }

    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedImage!.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: '이미지 자르기',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: false,
          ),
          IOSUiSettings(title: '이미지 자르기'),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _pickedImage = File(croppedFile.path);
        });
      } else {
        debugPrint("⚠️ 이미지 크롭 취소됨");
      }
    } catch (e) {
      debugPrint("❌ 이미지 크롭 실패: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("이미지를 자르는 중 오류 발생")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Media 패키지 비교")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 2.5.1 video_player
          Card(
            child: Column(
              children: [
                const Text("🎬 video_player", style: TextStyle(fontSize: 18)),
                if (_isVideoReady && _videoController != null)
                  AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _isVideoReady
                          ? () => setState(() {
                        _videoController!.play();
                      })
                          : null,
                      icon: const Icon(Icons.play_arrow),
                    ),
                    IconButton(
                      onPressed: _isVideoReady
                          ? () => setState(() {
                        _videoController!.pause();
                      })
                          : null,
                      icon: const Icon(Icons.pause),
                    ),
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 2.5.2 image_picker (+ 테스트 버튼)
          Card(
            child: Column(
              children: [
                const Text("🖼 image_picker", style: TextStyle(fontSize: 18)),
                _pickedImage == null
                    ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("선택된 이미지 없음"),
                )
                    : Image.file(_pickedImage!, height: 150),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _pickImage,
                        child: const Text("갤러리에서 이미지 선택"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _loadTestImage,
                        child: _isLoading
                            ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                            : const Text("테스트 이미지 불러오기"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 2.5.3 image_cropper
          Card(
            child: Column(
              children: [
                const Text("✂️ image_cropper", style: TextStyle(fontSize: 18)),
                _pickedImage == null
                    ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("먼저 이미지를 선택하세요"),
                )
                    : Image.file(_pickedImage!, height: 150),
                ElevatedButton(
                  onPressed: _cropImage,
                  child: const Text("이미지 자르기"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
