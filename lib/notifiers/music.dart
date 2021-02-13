import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusicProvider extends ChangeNotifier {
  bool _selectedMusic;
  AudioCache cache = AudioCache();
  AudioPlayer player = AudioPlayer();
  MusicProvider({bool isMusic}) {
    _selectedMusic = isMusic;
    // if (isMusic) {
    //   _playFile();
    // } else {
    //   _stopFile();
    // }
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

  // void _playFile() async {
  //   player = await cache.loop('sounds/drum_loop.mp3'); // assign player here
  // }

  // void _stopFile() {
  //   player?.stop(); // stop the file like this
  // }
}
