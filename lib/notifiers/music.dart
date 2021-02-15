import 'package:audio_session/audio_session.dart';
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

  void playFile() async {
    if (!player.playing) {
      await player.setAsset('assets/sounds/house_party.mp3');
      player.setSpeed(1.5);

      player.setLoopMode(LoopMode.all);
      player.play();
      handleInterruptions();
    } else {
      player.stop();
    }
  }

  void stopFile() {
    player.stop();
  }

  Future<void> pause() async {
    player.pause();
  }

  void handleInterruptions() {
    AudioSession.instance.then((session) async {
      player.playbackEventStream.listen((event) {
        // Activate session only if a song is playing
        if (player.playing) {
          session.setActive(true);
        }
      }).onError((e) => print(e));
      session.interruptionEventStream.listen((event) {
        if (event.begin) {
          // Another app started playing audio and we should pause.
          switch (event.type) {
            case AudioInterruptionType.duck:
              pause();
              break;

            case AudioInterruptionType.pause:
            // online media like youtube false under unknown
            case AudioInterruptionType.unknown:
              pause();
              // refresh notification

              break;
            default:
          }
        } else {
          // else block runs at the end of an interruption
          switch (event.type) {
            default:
          }
        }
      });
      session.becomingNoisyEventStream.listen((_) {
        // earphones unpluged
        pause();
      });
    });
  }
}
