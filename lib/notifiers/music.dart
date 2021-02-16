import 'dart:async';

import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusicProvider extends ChangeNotifier {
  bool _selectedMusic;

  MusicProvider({@required bool isMusic}) {
    _selectedMusic = isMusic;
    print(isMusic);
    SharedPreferences.getInstance().then((prefs) {
      bool isMusic = prefs.getBool('isMusic') ?? false;
      Flame.audio.disableLog();
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
    // prefs.setBool('isMusic', player.playerState.playing);
    notifyListeners();
  }

  bool get getMusic => _selectedMusic ?? false;

  // void playFile() async {
  //   if (!player.playing) {
  //     await player.setAsset('assets/sounds/house_party.mp3');

  //     player.setSpeed(1.5);
  //     player.setLoopMode(LoopMode.one);
  //     player.play();

  //   } else {
  //     stopFile();
  //   }
  // }

  // void stopFile() {
  //   player.stop();
  // }
  void playFile() {
    if (!Flame.bgm.isPlaying) {
      Flame.bgm.play('house_party.mp3', volume: .8);
    } else {
      stopFile();
    }
  }

  void stopFile() {
    Flame.audio.disableLog();
    Flame.bgm.stop();
  }
}
