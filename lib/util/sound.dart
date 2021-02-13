import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundProvider extends ChangeNotifier {
  bool _selectedSound;

  SoundProvider({bool isSound}) {
    _selectedSound = isSound;
  }
  Future<void> swapSound() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_selectedSound == true) {
      _selectedSound = false;
      prefs.setBool('isSound', false);
    } else {
      _selectedSound = true;
      prefs.setBool('isSound', true);
    }
    notifyListeners();
  }

  bool get getSound => _selectedSound;
}
