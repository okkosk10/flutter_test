import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:decimal/decimal.dart';

import '../manager/app_manager.dart';
import '../manager/wallet_controller.dart';

class ComparePage extends StatelessWidget {
  ComparePage({super.key});

  final WalletController controller = Get.put(WalletController());

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppManager>();

    return Scaffold(
      appBar: AppBar(title: const Text("Provider vs GetX 비교")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Provider 영역
            Text("🔵 Provider BNB: ${provider.bnbAmount}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => provider.addBnb(1),
              child: const Text("Provider BNB +1"),
            ),
            const Divider(height: 40),

            // GetX 영역
            Obx(() => Text("🟢 GetX BNB: ${controller.bnbAmount.value}",
                style: const TextStyle(fontSize: 18))),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => controller.addBnb(Decimal.fromInt(1)),
              child: const Text("GetX BNB +1"),
            ),
          ],
        ),
      ),
    );
  }
}
