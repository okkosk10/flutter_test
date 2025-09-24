import 'package:flutter/material.dart';

class AppManager extends ChangeNotifier {
  int _bnbAmount = 0;

  int get bnbAmount => _bnbAmount;

  void addBnb(int value) {
    _bnbAmount += value;
    notifyListeners(); // ✅ Provider는 반드시 notifyListeners 필요
  }
}