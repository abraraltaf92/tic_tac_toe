import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusicProvider extends ChangeNotifier {
  bool _selectedMusic;
  AudioPlayer player = AudioPlayer();

  MusicProvider({@required bool isMusic}) {
    _selectedMusic = isMusic;
    print(isMusic);

    SharedPreferences.getInstance().then((prefs) {
      bool isMusic = prefs.getBool('isMusic') ?? false;
      print(isMusic);
      if (isMusic) {
        playFile();
      } else {
        stopFile();
      }
    });
  }
  Future<void> swapMusic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (_selectedMusic == true) {
    //   _selectedMusic = false;
    //   prefs.setBool('isMusic', false);
    // } else {
    //   _selectedMusic = true;
    //   prefs.setBool('isMusic', true);
    // }
    prefs.setBool('isMusic', player.playerState.playing);
    notifyListeners();
  }

  bool get getMusic => _selectedMusic ?? false;

  void playFile() async {
    // if (!player.playerState.playing) {
    await player.setAsset('assets/sounds/drum_loop.mp3');
    player.play();
    // }
  }

  void stopFile() {
    player.stop();
  }
}
