import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:convert/convert.dart' as convert;

class CryptoComparePage extends StatefulWidget {
  const CryptoComparePage({super.key});

  @override
  State<CryptoComparePage> createState() => _CryptoComparePageState();
}

class _CryptoComparePageState extends State<CryptoComparePage> {
  String _mnemonic = '';
  String _seedHex = '';
  String _path = "m/44'/60'/0'/0/0"; // Ethereum 표준 경로
  String _privKeyHex = '';
  String _pubKeyHex = '';
  String _ethAddress = '';
  String _status = '대기 중...';

  /// 1) bip39: 니모닉 생성
  void _generateMnemonic() {
    try {
      final mnemonic = bip39.generateMnemonic(strength: 128); // 12 단어
      setState(() {
        _mnemonic = mnemonic;
        _seedHex = '';
        _privKeyHex = '';
        _pubKeyHex = '';
        _ethAddress = '';
        _status = '니모닉 생성 완료';
      });
    } catch (e) {
      setState(() => _status = '니모닉 생성 에러: $e');
    }
  }

  /// 2) bip39: 시드 생성 (니모닉 → 시드)
  void _mnemonicToSeed() {
    try {
      if (_mnemonic.isEmpty) {
        setState(() => _status = '먼저 니모닉을 생성하세요.');
        return;
      }
      final Uint8List seed = bip39.mnemonicToSeed(_mnemonic);
      setState(() {
        _seedHex = convert.hex.encode(seed);
        _status = '시드 생성 완료';
      });
    } catch (e) {
      setState(() => _status = '시드 생성 에러: $e');
    }
  }

  /// 3) bip32: 경로 파생 (Root → m/44'/60'/0'/0/0)
  void _deriveKeys() {
    try {
      if (_seedHex.isEmpty) {
        setState(() => _status = '먼저 시드를 생성하세요.');
        return;
      }
      final seed = Uint8List.fromList(convert.hex.decode(_seedHex));
      final root = bip32.BIP32.fromSeed(seed); // secp256k1
      final child = root.derivePath(_path);

      if (child.privateKey == null || child.publicKey == null) {
        setState(() => _status = '키 파생 실패: private/public key 없음');
        return;
      }

      final privHex = convert.hex.encode(child.privateKey!);
      final pubHex = convert.hex.encode(child.publicKey!);

      setState(() {
        _privKeyHex = privHex;
        _pubKeyHex = pubHex;
        _ethAddress = '';
        _status = '경로 파생 완료';
      });
    } catch (e) {
      setState(() => _status = '경로 파생 에러: $e');
    }
  }

  /// 4) web3dart: 개인키 → 이더리움 주소
  Future<void> _toEthereumAddress() async {
    try {
      if (_privKeyHex.isEmpty) {
        setState(() => _status = '먼저 개인키를 파생하세요.');
        return;
      }
      final creds = EthPrivateKey.fromHex(_privKeyHex);
      final address = await creds.extractAddress(); // checksummed address
      setState(() {
        _ethAddress = address.hexEip55;
        _status = '이더리움 주소 생성 완료';
      });
    } catch (e) {
      setState(() => _status = '주소 생성 에러: $e');
    }
  }

  /// convert 패키지 예시 (hex/base64 등)
  void _convertExamples() {
    try {
      if (_privKeyHex.isEmpty) {
        setState(() => _status = 'convert 예시는 개인키 파생 후 실행하세요.');
        return;
      }
      // 예: hex → bytes → hex round-trip
      final bytes = Uint8List.fromList(convert.hex.decode(_privKeyHex));
      final backToHex = convert.hex.encode(bytes);
      setState(() {
        _status = 'convert 테스트: hex round-trip 동일 여부 = ${backToHex == _privKeyHex}';
      });
    } catch (e) {
      setState(() => _status = 'convert 예시 에러: $e');
    }
  }

  Widget _kv(String k, String v, {int max = 4}) {
    // 긴 문자열은 앞/뒤만 표시
    String shorten(String s) {
      if (s.isEmpty) return '';
      if (s.length <= 12 * max) return s;
      final head = s.substring(0, 12 * max ~/ 2);
      final tail = s.substring(s.length - 12 * max ~/ 2);
      return '$head … $tail';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(k, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        SelectableText(shorten(v)),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('2.8 Crypto/Web3 비교')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _generateMnemonic,
                  child: const Text('1) 니모닉 생성 (bip39)'),
                ),
                ElevatedButton(
                  onPressed: _mnemonicToSeed,
                  child: const Text('2) 시드 생성 (bip39)'),
                ),
                ElevatedButton(
                  onPressed: _deriveKeys,
                  child: const Text('3) 키 파생 (bip32)'),
                ),
                ElevatedButton(
                  onPressed: _toEthereumAddress,
                  child: const Text('4) 주소 생성 (web3dart)'),
                ),
                ElevatedButton(
                  onPressed: _convertExamples,
                  child: const Text('5) convert 예시'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _kv('Mnemonic', _mnemonic, max: 6),
            _kv('Seed (hex)', _seedHex),
            _kv('Derivation Path', _path, max: 2),
            _kv('Private Key (hex)', _privKeyHex),
            _kv('Public Key (hex)', _pubKeyHex),
            _kv('Ethereum Address', _ethAddress, max: 2),
            const Divider(),
            Text(
              _status,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              '⚠️ 주의: 샘플에서는 학습/테스트 편의를 위해 키 정보를 화면에 표시합니다. '
                  '실서비스에서는 절대 개인키/시드/니모닉을 화면이나 로그에 노출하지 마세요.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
