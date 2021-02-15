import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:system_settings/system_settings.dart';
import 'package:tic_tac_toe/notifiers/haptics.dart';
import 'package:tic_tac_toe/notifiers/music.dart';
import 'package:tic_tac_toe/tile_state/board_tile.dart';
import 'package:tic_tac_toe/tile_state/tile_state.dart';
import 'package:tic_tac_toe/util/constants.dart';
import 'package:tic_tac_toe/ui/my_portfolio.dart';
import 'package:tic_tac_toe/util/licenses.dart';
import 'package:tic_tac_toe/notifiers/sound.dart';
import 'package:tic_tac_toe/notifiers/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _boardState = List<TileState>.filled(9, TileState.EMPTY);
  var _currentState = TileState.CROSS; //since Cross goes the first
  int countDraw = 0;
  bool isPlay = true;
  bool changeButton = false;
  static AudioCache player =
      AudioCache(prefix: 'assets/sounds/', respectSilence: false);
  @override
  void initState() {
    player.loadAll(['bubble_popping.mp3', 'win.mp3', 'draw.mp3', 'whoosh.mp3']);
    super.initState();
  }

  @override
  void dispose() {
    player.clearCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<ThemeProvider, SoundProvider, HapticProvider,
            MusicProvider>(
        builder: (context, themeProvider, soundProvider, hapticProvider,
            musicProvider, child) {
      themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      soundProvider = Provider.of<SoundProvider>(context, listen: false);
      hapticProvider = Provider.of<HapticProvider>(context, listen: false);
      musicProvider = Provider.of<MusicProvider>(context, listen: false);
      bool isDark = themeProvider.getTheme == ThemeData.dark();
      bool isSound = soundProvider.getSound;
      bool isHaptic = hapticProvider.gethaptic;
      bool isMusic = musicProvider.getMusic;
      bool isHapticPermission = hapticProvider.getHapticPermisiion;
      return Scaffold(
        appBar: AppBar(
          title: const Text('Tic Tac Toe'),
          centerTitle: true,
          actions: [
            _bulbIconButton(
                themeProvider: themeProvider,
                isDark: isDark,
                isSound: isSound,
                isHaptic: isHaptic),
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
                  _instagramTile(isHaptic: isHaptic),
                  _facebookTile(isHaptic: isHaptic),
                  Divider(),
                  _myPortfolioTile(isHaptic: isHaptic),
                  Divider(),
                  _shareTile(isHaptic: isHaptic),
                  _aboutAppTile(isHaptic: isHaptic),
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
                        _letsPlay(isDark: isDark, isHaptic: isHaptic),
                        _soundEffects(
                            isDark: isDark,
                            soundProvider: soundProvider,
                            isSound: isSound),
                        _hapticFeedback(
                            isDark: isDark,
                            hapticProvider: hapticProvider,
                            isHaptic: isHaptic,
                            isHapticPermission: isHapticPermission),
                        _musicEffects(
                            isDark: isDark,
                            musicProvider: musicProvider,
                            isMusic: isMusic),
                        _aboutMe(
                            isDark: isDark,
                            isSound: isSound,
                            isHaptic: isHaptic),
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
            isPlay ? null : _speedDial(isDark: isDark, isHaptic: isHaptic),
      );
    });
  }

  // AppBar
  IconButton _bulbIconButton(
      {@required bool isHaptic,
      @required ThemeProvider themeProvider,
      @required bool isDark,
      @required bool isSound}) {
    return IconButton(
      onPressed: () {
        if (isHaptic) {
          HapticFeedback.mediumImpact();
        }
        if (isSound) {
          player.play('whoosh.mp3');
        }
        themeProvider.swapTheme();
      },
      icon: Icon(isDark ? (Icons.lightbulb) : Icons.lightbulb_outline),
      color: isDark ? Colors.yellow : null,
    );
  }

  // Drawer

  ListTile _instagramTile({@required bool isHaptic}) {
    return ListTile(
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
    );
  }

  ListTile _facebookTile({@required bool isHaptic}) {
    return ListTile(
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
    );
  }

  ListTile _myPortfolioTile({@required bool isHaptic}) {
    return ListTile(
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
    );
  }

  ListTile _shareTile({@required bool isHaptic}) {
    return ListTile(
      onTap: () {
        if (isHaptic) {
          HapticFeedback.lightImpact();
        }
        if (Platform.isAndroid) {
          Share.share(googlePlayStoreLink, subject: 'Share Tic Tac Toe');
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
    );
  }

  ListTile _aboutAppTile({@required bool isHaptic}) {
    return ListTile(
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
    );
  }

  // Home Widgets
  AnimatedContainer _letsPlay(
      {@required bool isDark, @required bool isHaptic}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: changeButton
          ? MediaQuery.of(context).size.width * 0.35 / 3
          : MediaQuery.of(context).size.width * 0.5,
      child: ElevatedButton(
        child: changeButton ? Icon(FontAwesome.angellist) : Text('Let\'s play'),
        style: ButtonStyle(
            backgroundColor: isDark
                ? MaterialStateColor.resolveWith((states) => Colors.white54)
                : null,
            foregroundColor: isDark
                ? MaterialStateColor.resolveWith((states) => Colors.black)
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
    );
  }

  Container _soundEffects(
      {@required bool isDark,
      @required bool isSound,
      @required SoundProvider soundProvider}) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: ElevatedButton(
          child: (isSound)
              ? Text(
                  'Sound Effects: off',
                  textAlign: TextAlign.center,
                )
              : Text('Sound Effects: on', textAlign: TextAlign.center),
          style: ButtonStyle(
              backgroundColor: isDark
                  ? MaterialStateColor.resolveWith((states) => Colors.white54)
                  : null,
              foregroundColor: isDark
                  ? MaterialStateColor.resolveWith((states) => Colors.black)
                  : null),
          onPressed: () async {
            await soundProvider.swapSound();
          },
        ));
  }

  Container _hapticFeedback(
      {@required bool isDark,
      @required bool isHaptic,
      @required bool isHapticPermission,
      @required HapticProvider hapticProvider}) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: ElevatedButton(
          child: (isHaptic)
              ? Text(
                  'Haptics: off',
                  textAlign: TextAlign.center,
                )
              : Text('Haptics: on', textAlign: TextAlign.center),
          style: ButtonStyle(
              backgroundColor: isDark
                  ? MaterialStateColor.resolveWith((states) => Colors.white54)
                  : null,
              foregroundColor: isDark
                  ? MaterialStateColor.resolveWith((states) => Colors.black)
                  : null),
          onPressed: () async {
            await hapticProvider.swapHaptic();

            if (isHapticPermission) {
              if (Platform.isIOS) {
                showCupertinoDialog(
                    context: context,
                    builder: (_) {
                      return CupertinoAlertDialog(
                        title: const Text(
                          'Alert',
                          style: TextStyle(color: Colors.red),
                        ),
                        content: Container(
                            child: Column(children: <Widget>[
                          Text('Turn on System Haptics on your Iphone'),
                          Divider(
                            color: Colors.transparent,
                          ),
                          Row(
                            children: [
                              Text(
                                'Follow : ',
                                textAlign: TextAlign.start,
                                style: TextStyle(color: Colors.red),
                              ),
                              Expanded(
                                child: Text(
                                    'Settings > Sounds & Haptics > System Haptics'),
                              )
                            ],
                          ),
                        ])),
                        actions: [
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();

                                SystemSettings.app();
                              },
                              child: const Text('Settings')),
                          FlatButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await hapticProvider.swapPermission();
                              },
                              child: const Text('OK'))
                        ],
                      );
                    });
              } else {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text(
                          'Alert',
                          style: TextStyle(color: Colors.red),
                        ),
                        content: Container(
                            child: Column(children: <Widget>[
                          Text('Turn on System Haptics on your Iphone'),
                          Divider(
                            color: Colors.transparent,
                          ),
                          Row(
                            children: [
                              Text(
                                'Follow : ',
                                textAlign: TextAlign.start,
                                style: TextStyle(color: Colors.red),
                              ),
                              Expanded(
                                child: Text(
                                    'Settings > Sound & Vibrate > Vibrate on touch'),
                              )
                            ],
                          ),
                        ])),
                        actions: [
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                SystemSettings.app();
                              },
                              child: const Text('Settings')),
                          FlatButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await hapticProvider.swapPermission();
                              },
                              child: const Text('OK'))
                        ],
                      );
                    });
              }
            }
          },
        ));
  }

  Container _musicEffects(
      {@required bool isDark,
      @required bool isMusic,
      @required MusicProvider musicProvider}) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: ElevatedButton(
          child: (isMusic)
              ? Text(
                  'Music: off',
                  textAlign: TextAlign.center,
                )
              : Text('Music: on', textAlign: TextAlign.center),
          // child: Text(
          //   'Music: on',
          //   textAlign: TextAlign.center,
          // ),
          style: ButtonStyle(
              backgroundColor: isDark
                  ? MaterialStateColor.resolveWith((states) => Colors.white54)
                  : null,
              foregroundColor: isDark
                  ? MaterialStateColor.resolveWith((states) => Colors.black)
                  : null),
          onPressed: () async {
            // Get.to(Test());

            if (!isMusic) {
              musicProvider.playFile();
            } else {
              musicProvider.stopFile();
            }
            await musicProvider.swapMusic();

            // _displaySnack(
            //     msg: 'Work in progress...',
            //     isDark: isDark,
            //     gravity: ToastGravity.CENTER);
          },
        ));
  }

  Container _aboutMe(
      {@required bool isDark,
      @required bool isHaptic,
      @required bool isSound}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      child: ElevatedButton(
        child: const Text('About us'),
        style: ButtonStyle(
            backgroundColor: isDark
                ? MaterialStateColor.resolveWith((states) => Colors.white54)
                : null,
            foregroundColor: isDark
                ? MaterialStateColor.resolveWith((states) => Colors.black)
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
    );
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
              onPressed: () async {
                if (isHaptic) {
                  HapticFeedback.lightImpact();
                }
                _updateTileStateForIndex(
                    selectedIndex: tileIndex, isDark: isDark, isSound: isSound);
                if (isSound && tileState == TileState.EMPTY) {
                  player.play('bubble_popping.mp3');
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

  // Game Logic
  void _updateTileStateForIndex(
      {@required int selectedIndex,
      @required bool isDark,
      @required bool isSound}) {
    if (_boardState[selectedIndex] == TileState.EMPTY) {
      setState(() {
        _boardState[selectedIndex] = _currentState;
        _currentState = _currentState == TileState.CROSS
            ? TileState.CIRCLE
            : TileState.CROSS;
      });

      final winner = _findWinner();
      if (winner != null) {
        _showWinnerDialog(tileState: winner, isDark: isDark, isSound: isSound);
      } else {
        countDraw += 1;
        if (countDraw == 9) {
          _showDrawDialog(isDark: isDark, isSound: isSound);
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

  void _showWinnerDialog(
      {@required TileState tileState,
      @required bool isDark,
      @required bool isSound}) {
    showDialog(
        context: context,
        builder: (_) {
          if (Platform.isIOS) {
            if (isSound) {
              player.play('win.mp3');
            }

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
            if (isSound) {
              player.play('win.mp3');
            }
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

  void _showDrawDialog({@required bool isDark, @required bool isSound}) {
    showDialog(
        context: context,
        builder: (_) {
          if (Platform.isIOS) {
            if (isSound) {
              player.play('draw.mp3');
            }
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
            if (isSound) {
              player.play('draw.mp3');
            }
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
}

//
