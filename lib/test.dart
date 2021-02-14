// import 'package:audioplayers/audio_cache.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';

// class Test extends StatefulWidget {
//   @override
//   _TestState createState() => _TestState();
// }

// class _TestState extends State<Test> {
//   AudioPlayer audioPlayer = AudioPlayer();
//   AudioCache cache = AudioCache();
//   // _play() {
//   //   return audioPlayer.stop();
//   // }

//   Future<AudioPlayer> playLocalAsset() async {
//     return await cache.loop("sounds/myCustomSoundEffect.mp3");
//   }

//   Future<int> stopLocalAsset() async {
//     return await audioPlayer.stop();
//   }

//   bool isSound = true;
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               child: ElevatedButton(
//                 onPressed: () {
//                   final player = AudioCache();
//                   player.play('sounds/myCustomSoundEffect.mp3');
//                 },
//                 child: Text('Play'),
//               ),
//             ),
//             Container(
//               child: ElevatedButton(
//                 onPressed: () async {
//                   await audioPlayer.earpieceOrSpeakersToggle();
//                 },
//                 child: Text('Toggle'),
//               ),
//             ),
//             Container(
//               child: ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     isSound = !isSound;
//                   });
//                 },
//                 child: Text('Sound Off'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
