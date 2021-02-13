import 'package:audioplayers/audio_cache.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class SoundProvider extends ChangeNotifier {
  SoundProvider({this.fileName});
  String fileName;
  // AudioPlayer _selectedTone;
  AudioCache cache = AudioCache();
  // AudioPlayer play = cache.play('aad');
}
