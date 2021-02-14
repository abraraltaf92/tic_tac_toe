import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HapticProvider extends ChangeNotifier {
  bool _selectedHaptic;

  HapticProvider({bool isHaptic}) {
    _selectedHaptic = isHaptic;
  }
  Future<void> swapHaptic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_selectedHaptic == true) {
      _selectedHaptic = false;
      prefs.setBool('isSound', false);
    } else {
      _selectedHaptic = true;
      prefs.setBool('isSound', true);
    }
    notifyListeners();
  }

  bool get gethaptic => _selectedHaptic;
}
