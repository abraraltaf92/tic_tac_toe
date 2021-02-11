import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:tic_tac_toe/board_tile.dart';
import 'package:tic_tac_toe/my_portfolio.dart';
import 'package:tic_tac_toe/theme.dart';
import 'package:tic_tac_toe/tile_state.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _boardState = List<TileState>.filled(9, TileState.EMPTY);
  var _currentState = TileState.CROSS; //since Cross goes the first
  int countDraw = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isDark = true;
  bool isPlay = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      bool isDark = themeProvider.getTheme == ThemeData.dark();
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Tic Tac Toe'),
          actions: [
            IconButton(
              onPressed: () {
                ThemeProvider themeProvider =
                    Provider.of<ThemeProvider>(context, listen: false);
                themeProvider.swapTheme();

                setState(() {
                  isDark = !isDark;
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
                      const url = 'https://instagram.com/abraraltaf92';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    leading: const Icon(Icons.circle),
                    title: const Text(
                      "Instagram",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      const url = 'https://www.facebook.com/abrar.altaf1/';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    leading: const Icon(Icons.circle),
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
                      const url = 'https://abrar-altaf92.web.app';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    leading: const Icon(Icons.circle),
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
                      if (Platform.isAndroid) {
                        Share.share(
                            'https://play.google.com/store/apps/details?id=com.abraraltaf.tic_tac_toe',
                            subject: 'Share Tic Tac Toe');
                      } else {
                        Share.share('itms-apps//');
                      }
                    },
                    leading: const Icon(Icons.circle),
                    title: const Text(
                      "Share with your friend",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () => showAboutDialog(
                        context: context,
                        applicationIcon: Image.asset(
                          'images/logo.png',
                          width: MediaQuery.of(context).size.width * 0.1,
                        ),
                        applicationVersion: '0.0.1',
                        applicationName: 'Tic Tac Toe',
                        applicationLegalese: 'Developed by Abrar Altaf Lone',
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: const Text(
                              'Tic-tac-toe, is a simple mobile game for two players, X and O, who take turns marking the spaces in a 3×3 grid. The player who succeeds in placing three of their marks in a diagonal, horizontal, or vertical row is the winner.',
                            ),
                          )
                        ]),
                    // onPressed: null,
                    leading: const Icon(Icons.circle),
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
                    'images/board.png',
                    color: Colors.grey.withOpacity(0.03),
                  )),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: ElevatedButton(
                            child: const Text('Let\'s play'),
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
                              setState(() {
                                isPlay = !isPlay;
                              });
                            },
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: ElevatedButton(
                            child: const Text('About Us'),
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
                              Get.to(MyPortfolio(isDark: isDark));
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
                        'images/board.png',
                        color: isDark ? Colors.white54 : Colors.black,
                      ),
                      _boardTiles(),
                    ],
                  ),
                ),
              ),
        floatingActionButton: isPlay
            ? null
            : SpeedDial(
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
                        _resetGame();
                        _displaySnack(msg: 'Game Restarted');
                      },
                      label: 'Restart',
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          color: isDark ? Colors.black : null),
                      labelBackgroundColor: Colors.white54),

                  SpeedDialChild(
                      child: const Icon(Icons.close),
                      backgroundColor: Colors.white54,
                      onTap: () {
                        _resetGame();
                        setState(() {
                          isPlay = !isPlay;
                        });
                      },
                      label: 'Quit',
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.black : null,
                          fontSize: 16.0),
                      labelBackgroundColor: Colors.white54)
                ],
              ),
      );
    });
  }

  Widget _boardTiles() {
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
              onPressed: () => _updateTileStateForIndex(tileIndex),
            );
          }).toList()); // [ [TileState.EMPTY,TileState.EMPTY,TileState.EMPTY,][...][...]]
        }).toList()),
      );
    });
  }

  void _updateTileStateForIndex(int selectedIndex) {
    if (_boardState[selectedIndex] == TileState.EMPTY) {
      setState(() {
        _boardState[selectedIndex] = _currentState;
        _currentState = _currentState == TileState.CROSS
            ? TileState.CIRCLE
            : TileState.CROSS;
      });

      final winner = _findWinner();
      if (winner != null) {
        _showWinnerDialog(winner);
      } else {
        countDraw += 1;
        if (countDraw == 9) {
          _showDrawDialog();
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

  void _showWinnerDialog(TileState tileState) {
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
                        ? 'images/x.png'
                        : 'images/o.png',
                  ),
                  Lottie.asset('images/surprise.json')
                ],
              ),
              actions: [
                FlatButton(
                    onPressed: () {
                      _resetGame();
                      Navigator.of(context).pop();
                      _displaySnack(
                          msg: 'NewGame Started', gravity: ToastGravity.CENTER);
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
                        ? 'images/x.png'
                        : 'images/o.png',
                  ),
                  Lottie.asset('images/surprise.json')
                ],
              ),
              actions: [
                FlatButton(
                    onPressed: () {
                      _resetGame();
                      Navigator.of(context).pop();
                      _displaySnack(
                          msg: 'NewGame Started', gravity: ToastGravity.CENTER);
                    },
                    child: const Text('New Game'))
              ],
            );
          }
        });
  }

  void _showDrawDialog() {
    showDialog(
        context: context,
        builder: (_) {
          if (Platform.isIOS) {
            return CupertinoAlertDialog(
              title: const Text("RESULT"),
              content: Image.asset(
                'images/tie.png',
                color: Colors.red,
              ),
              actions: [
                FlatButton(
                    onPressed: () {
                      _resetGame();
                      Navigator.of(context).pop();
                      _displaySnack(
                          msg: 'NewGame Started', gravity: ToastGravity.CENTER);
                    },
                    child: const Text('New Game'))
              ],
            );
          } else {
            return AlertDialog(
              title: const Text("RESULT"),
              content: Image.asset('images/tie.png', color: Colors.red),
              actions: [
                FlatButton(
                    onPressed: () {
                      _resetGame();
                      Navigator.of(context).pop();
                      _displaySnack(
                          msg: 'NewGame Started', gravity: ToastGravity.CENTER);
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

  void _displaySnack({@required String msg, ToastGravity gravity}) {
    Fluttertoast.showToast(
      msg: msg,
      gravity: gravity,
    );
  }
}

//
