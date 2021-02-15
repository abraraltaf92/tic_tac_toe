import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HapticProvider extends ChangeNotifier {
  bool _selectedHaptic;
  bool _selectedHapticPermission;
  HapticProvider({bool isHaptic, bool isHapticPemission}) {
    _selectedHaptic = isHaptic;
    _selectedHapticPermission = isHapticPemission;
  }
  Future<void> swapHaptic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_selectedHaptic == true) {
      _selectedHaptic = false;
      prefs.setBool('isHaptic', false);
    } else {
      _selectedHaptic = true;
      prefs.setBool('isHaptic', true);
    }

    notifyListeners();
  }

  Future<void> swapPermission() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_selectedHapticPermission == true) {
      _selectedHapticPermission = false;
      prefs.setBool('isHapticPermission', false);
    }
    notifyListeners();
  }

  bool get gethaptic => _selectedHaptic ?? false;
  bool get getHapticPermisiion => _selectedHapticPermission ?? true;
}
