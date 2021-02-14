import 'dart:io';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:tic_tac_toe/notifiers/haptics.dart';
import 'package:tic_tac_toe/tile_state/board_tile.dart';
import 'package:tic_tac_toe/tile_state/tile_state.dart';
import 'package:tic_tac_toe/util/constants.dart';
import 'package:tic_tac_toe/ui/my_portfolio.dart';
import 'package:tic_tac_toe/util/licenses.dart';
// import 'package:tic_tac_toe/notifiers/music.dart';
import 'package:tic_tac_toe/notifiers/sound.dart';
import 'package:tic_tac_toe/notifiers/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  //  for functions other then build widget (general)
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _boardState = List<TileState>.filled(9, TileState.EMPTY);
  var _currentState = TileState.CROSS; //since Cross goes the first
  int countDraw = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isPlay = true;
  AudioCache cache = AudioCache(); // you have this
  AudioPlayer player = AudioPlayer();
  bool changeButton = false;
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    SoundProvider soundProvider =
        Provider.of<SoundProvider>(context, listen: false);
    HapticProvider hapticProvider =
        Provider.of<HapticProvider>(context, listen: false);
    // MusicProvider musicProvider =
    //     Provider.of<MusicProvider>(context, listen: false);

    bool isDark = themeProvider.getTheme == ThemeData.dark();
    bool isSound = soundProvider.getSound;
    bool isHaptic = hapticProvider.gethaptic;
    // bool isMusic = musicProvider.getMusic;
    // if (isMusic) {
    //   if (cache.fixedPlayer?.playerId != 'abc') _playFile();
    // } else {
    //   _stopFile();
    // }
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Tic Tac Toe'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                if (isHaptic) {
                  HapticFeedback.mediumImpact();
                }
                themeProvider.swapTheme();
                setState(() {
                  isDark = isDark;
                });
              },
              icon: Icon(isDark ? (Icons.lightbulb) : Icons.lightbulb_outline),
              color: isDark ? Colors.yellow : null,
            ),
          ],
        ),
        drawer: Drawer(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ListView(
                shrinkWrap: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: const Text(
                      'Follow us on:',
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      if (isHaptic) {
                        HapticFeedback.lightImpact();
                      }
                      const url = instaLink;
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    leading: const Icon(FontAwesome.instagram),
                    title: const Text(
                      "Instagram",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      if (isHaptic) {
                        HapticFeedback.lightImpact();
                      }
                      const url = fbLink;
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    leading: const Icon(FontAwesome.facebook),
                    title: const Text(
                      "Facebook",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () async {
                      if (isHaptic) {
                        HapticFeedback.lightImpact();
                      }
                      const url = myPortfolio;
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    leading: const Icon(FontAwesome.file_powerpoint_o),
                    title: const Text(
                      "Portfolio",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () {
                      if (isHaptic) {
                        HapticFeedback.lightImpact();
                      }
                      if (Platform.isAndroid) {
                        Share.share(googlePlayStoreLink,
                            subject: 'Share Tic Tac Toe');
                      } else {
                        Share.share('itms-apps//');
                      }
                    },
                    leading: const Icon(FontAwesome.share),
                    title: const Text(
                      "Share with your friend",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      if (isHaptic) {
                        HapticFeedback.lightImpact();
                      }
                      showLicense(context: context);
                    },
                    // onPressed: null,
                    leading: const Icon(FontAwesome.info_circle),
                    title: const Text(
                      "About app",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: isPlay
            ? SafeArea(
                child: Stack(
                children: [
                  Center(
                      child: Image.asset(
                    'assets/images/board.png',
                    color: Colors.grey.withOpacity(0.03),
                  )),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: changeButton
                              ? MediaQuery.of(context).size.width * 0.35 / 3
                              : MediaQuery.of(context).size.width * 0.35,
                          child: ElevatedButton(
                            child: changeButton
                                ? Icon(FontAwesome.angellist)
                                : Text('Let\'s play'),
                            style: ButtonStyle(
                                backgroundColor: isDark
                                    ? MaterialStateColor.resolveWith(
                                        (states) => Colors.white54)
                                    : null,
                                foregroundColor: isDark
                                    ? MaterialStateColor.resolveWith(
                                        (states) => Colors.black)
                                    : null),
                            onPressed: () async {
                              if (isHaptic) {
                                HapticFeedback.lightImpact();
                              }
                              setState(() {
                                changeButton = !changeButton;
                              });
                              await Future.delayed(Duration(milliseconds: 320));
                              setState(() {
                                isPlay = !isPlay;
                              });
                            },
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: ElevatedButton(
                            child: (isSound)
                                ? Text(
                                    'Sound Effects: off',
                                    textAlign: TextAlign.center,
                                  )
                                : Text('Sound Effects: on',
                                    textAlign: TextAlign.center),
                            style: ButtonStyle(
                                backgroundColor: isDark
                                    ? MaterialStateColor.resolveWith(
                                        (states) => Colors.white54)
                                    : null,
                                foregroundColor: isDark
                                    ? MaterialStateColor.resolveWith(
                                        (states) => Colors.black)
                                    : null),
                            onPressed: () async {
                              // Get.to(Test());

                              await soundProvider.swapSound();

                              setState(() {
                                isSound = isSound;
                              });
                            },
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: ElevatedButton(
                            child: (isHaptic)
                                ? Text(
                                    'Haptics: off',
                                    textAlign: TextAlign.center,
                                  )
                                : Text('Haptics: on',
                                    textAlign: TextAlign.center),
                            style: ButtonStyle(
                                backgroundColor: isDark
                                    ? MaterialStateColor.resolveWith(
                                        (states) => Colors.white54)
                                    : null,
                                foregroundColor: isDark
                                    ? MaterialStateColor.resolveWith(
                                        (states) => Colors.black)
                                    : null),
                            onPressed: () async {
                              // Get.to(Test());

                              await hapticProvider.swapHaptic();

                              setState(() {
                                isHaptic = isHaptic;
                              });
                            },
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: ElevatedButton(
                            // child: (isMusic)
                            //     ? Text(
                            //         'Music: off',
                            //         textAlign: TextAlign.center,
                            //       )
                            //     : Text('Music: on',
                            //         textAlign: TextAlign.center),
                            child: Text(
                              'Music: on',
                              textAlign: TextAlign.center,
                            ),
                            style: ButtonStyle(
                                backgroundColor: isDark
                                    ? MaterialStateColor.resolveWith(
                                        (states) => Colors.white54)
                                    : null,
                                foregroundColor: isDark
                                    ? MaterialStateColor.resolveWith(
                                        (states) => Colors.black)
                                    : null),
                            onPressed: () async {
                              // Get.to(Test());

                              // await musicProvider.swapMusic();
                              // print(isMusic);

                              // setState(() {
                              //   isMusic = !isMusic;
                              // });
                              _displaySnack(
                                  msg: 'Work in progress...',
                                  isDark: isDark,
                                  gravity: ToastGravity.CENTER);
                            },
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: ElevatedButton(
                            child: const Text('About us'),
                            style: ButtonStyle(
                                backgroundColor: isDark
                                    ? MaterialStateColor.resolveWith(
                                        (states) => Colors.white54)
                                    : null,
                                foregroundColor: isDark
                                    ? MaterialStateColor.resolveWith(
                                        (states) => Colors.black)
                                    : null),
                            onPressed: () {
                              if (isHaptic) {
                                HapticFeedback.lightImpact();
                              }
                              Get.to(MyPortfolio(
                                isDark: isDark,
                                isSound: isSound,
                              ));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ))
            : SafeArea(
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/board.png',
                        color: isDark ? Colors.white54 : Colors.black,
                      ),
                      _boardTiles(
                          isSound: isSound, isDark: isDark, isHaptic: isHaptic),
                    ],
                  ),
                ),
              ),
        floatingActionButton:
            isPlay ? null : _speedDial(isDark: isDark, isHaptic: isHaptic));
  }

  Widget _speedDial({@required bool isDark, @required bool isHaptic}) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.view_list,
      animatedIconTheme: IconThemeData(size: 25),
      backgroundColor: Colors.white70,
      foregroundColor: Colors.black,
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 1
        SpeedDialChild(
            child: const Icon(Icons.replay_outlined),
            backgroundColor: Colors.white54,
            onTap: () {
              if (isHaptic) {
                HapticFeedback.lightImpact();
              }
              _resetGame();
              _displaySnack(msg: 'Game Restarted', isDark: isDark);
            },
            label: 'Restart',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
                color: Colors.black),
            labelBackgroundColor: Colors.white54),

        SpeedDialChild(
            child: const Icon(Icons.close),
            backgroundColor: Colors.white54,
            onTap: () {
              if (isHaptic) {
                HapticFeedback.lightImpact();
              }
              _resetGame();
              setState(() {
                isPlay = !isPlay;
                changeButton = !changeButton;
              });
            },
            label: 'Quit',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 16.0),
            labelBackgroundColor: Colors.white54)
      ],
    );
  }

  Widget _boardTiles(
      {@required bool isSound,
      @required bool isDark,
      @required bool isHaptic}) {
    return Builder(builder: (context) {
      final boardWidth = MediaQuery.of(context).size.width;
      final tileWidth = boardWidth / 3;
      return Container(
        height: boardWidth,
        width: boardWidth,
        child: Column(
            children: chunk(_boardState, 3).asMap().entries.map((entry) {
          final chunkIndex = entry.key; // [ 0 , 1 , 2]
          final tileStateChunk = entry.value;

          return Row(
              children: tileStateChunk.asMap().entries.map((innerEntry) {
            final innerIndex = innerEntry.key;
            final tileState = innerEntry.value;
            final tileIndex = (chunkIndex * 3) + innerIndex;

            return BoardTile(
              tileState: tileState,
              dimension: tileWidth,
              onPressed: () {
                if (isHaptic) {
                  HapticFeedback.lightImpact();
                }
                _updateTileStateForIndex(tileIndex, isDark);
                if (isSound && tileState == TileState.EMPTY) {
                  final player = AudioCache();
                  player.play('sounds/bubble_popping.mp3');

                  // SystemSound.play(SystemSoundType.click);
                }
                if (tileState != TileState.EMPTY) {
                  _displaySnack(
                      msg: 'Space occupied',
                      gravity: ToastGravity.CENTER,
                      isDark: isDark);
                }
              },
            );
          }).toList()); // [ [TileState.EMPTY,TileState.EMPTY,TileState.EMPTY,][...][...]]
        }).toList()),
      );
    });
  }

  void _updateTileStateForIndex(int selectedIndex, bool isDark) {
    if (_boardState[selectedIndex] == TileState.EMPTY) {
      setState(() {
        _boardState[selectedIndex] = _currentState;
        _currentState = _currentState == TileState.CROSS
            ? TileState.CIRCLE
            : TileState.CROSS;
      });

      final winner = _findWinner();
      if (winner != null) {
        _showWinnerDialog(winner, isDark);
      } else {
        countDraw += 1;
        if (countDraw == 9) {
          _showDrawDialog(isDark: isDark);
        }
      }
    }
  }

  TileState _findWinner() {
    TileState Function(int, int, int) winnerForMatch = (a, b, c) {
      if (_boardState[a] != TileState.EMPTY) {
        if ((_boardState[a] == _boardState[b]) &&
            (_boardState[b] == _boardState[c])) {
          return _boardState[a];
        }
      }
      return null;
    };

    final checks = [
      winnerForMatch(0, 1, 2),
      winnerForMatch(3, 4, 5),
      winnerForMatch(6, 7, 8),
      winnerForMatch(0, 3, 6),
      winnerForMatch(1, 4, 7),
      winnerForMatch(2, 5, 8),
      winnerForMatch(0, 4, 8),
      winnerForMatch(2, 4, 6),
    ];
    TileState winner;

    winner = checks.firstWhere((TileState element) => element != null,
        orElse: () => null);

    return winner;
  }

  void _showWinnerDialog(TileState tileState, bool isDark) {
    showDialog(
        context: context,
        builder: (_) {
          if (Platform.isIOS) {
            return CupertinoAlertDialog(
              title: const Text("Winner"),
              content: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    tileState == TileState.CROSS
                        ? 'assets/images/x.png'
                        : 'assets/images/o.png',
                  ),
                  Lottie.asset('assets/images/surprise.json')
                ],
              ),
              actions: [
                FlatButton(
                    onPressed: () {
                      _resetGame();
                      Navigator.of(context).pop();
                      _displaySnack(
                          msg: 'NewGame Started',
                          gravity: ToastGravity.CENTER,
                          isDark: isDark);
                    },
                    child: const Text('New Game'))
              ],
            );
          } else {
            return AlertDialog(
              title: const Text("Winner"),
              content: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    tileState == TileState.CROSS
                        ? 'assets/images/x.png'
                        : 'assets/images/o.png',
                  ),
                  Lottie.asset('assets/images/surprise.json')
                ],
              ),
              actions: [
                FlatButton(
                    onPressed: () {
                      _resetGame();
                      Navigator.of(context).pop();
                      _displaySnack(
                          msg: 'NewGame Started',
                          gravity: ToastGravity.CENTER,
                          isDark: isDark);
                    },
                    child: const Text('New Game'))
              ],
            );
          }
        });
  }

  void _showDrawDialog({@required bool isDark}) {
    showDialog(
        context: context,
        builder: (_) {
          if (Platform.isIOS) {
            return CupertinoAlertDialog(
              title: const Text("RESULT"),
              content: Image.asset(
                'assets/images/tie.png',
                color: Colors.red,
              ),
              actions: [
                FlatButton(
                    onPressed: () {
                      _resetGame();
                      Navigator.of(context).pop();
                      _displaySnack(
                          msg: 'NewGame Started',
                          gravity: ToastGravity.CENTER,
                          isDark: isDark);
                    },
                    child: const Text('New Game'))
              ],
            );
          } else {
            return AlertDialog(
              title: const Text("RESULT"),
              content: Image.asset('assets/images/tie.png', color: Colors.red),
              actions: [
                FlatButton(
                    onPressed: () {
                      _resetGame();
                      Navigator.of(context).pop();
                      _displaySnack(
                          msg: 'NewGame Started',
                          gravity: ToastGravity.CENTER,
                          isDark: isDark);
                    },
                    child: const Text('New Game'))
              ],
            );
          }
        });
  }

  void _resetGame() {
    setState(() {
      _boardState = List.filled(9, TileState.EMPTY);
      _currentState = TileState.CROSS;
      countDraw = 0;
    });
  }

  void _displaySnack(
      {@required String msg, ToastGravity gravity, @required bool isDark}) {
    Fluttertoast.showToast(
      msg: msg,
      gravity: gravity,
      backgroundColor: isDark ? Colors.black : Colors.grey,
    );
  }

  void _playFile() async {
    player = await cache.loop(
      'sounds/drum_loop.mp3',
      volume: 0.5,
    );

    // assign player here
  }

  void _stopFile() {
    player?.stop(); // stop the file like this
  }
}

//
