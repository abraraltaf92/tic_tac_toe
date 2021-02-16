import 'dart:async';

import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusicProvider extends ChangeNotifier {
  bool _selectedMusic;

  MusicProvider({@required bool isMusic}) {
    _selectedMusic = isMusic;
    SharedPreferences.getInstance().then((prefs) {
      bool isMusic = prefs.getBool('isMusic') ?? false;

      if (isMusic) {
        playFile();
      }
    });
  }
  Future<void> swapMusic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_selectedMusic == true) {
      _selectedMusic = false;
      prefs.setBool('isMusic', false);
    } else {
      _selectedMusic = true;
      prefs.setBool('isMusic', true);
    }
    notifyListeners();
  }

  bool get getMusic => _selectedMusic ?? false;

  void playFile() {
    if (!Flame.bgm.isPlaying) {
      Flame.bgm.play('house_party.mp3', volume: .8);
    } else {
      stopFile();
    }
  }

  void stopFile() {
    Flame.bgm.stop();
  }
}
