import 'package:get/get.dart';
import 'package:decimal/decimal.dart';

class WalletController extends GetxController {
  Rx<Decimal> bnbAmount = Decimal.fromInt(0).obs;

  void addBnb(Decimal value) {
    bnbAmount.value += value; // ✅ GetX는 값만 바꿔도 UI 자동 갱신
  }
}