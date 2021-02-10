import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/board_tile.dart';
import 'package:tic_tac_toe/theme.dart';
import 'package:tic_tac_toe/tile_state.dart';

class Home extends StatefulWidget {
  final bool isDarkMode;
  Home({this.isDarkMode});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _boardState = List<TileState>.filled(9, TileState.EMPTY);
  var _currentState = TileState.CROSS; //since Cross goes the first
  int countDraw = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isDark = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      bool isDark = themeProvider.getTheme == ThemeData.dark();
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Tic Tac Toe'),
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
        body: SafeArea(
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
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white54,
            foregroundColor: Colors.black,
            child: Icon(Icons.replay_outlined),
            onPressed: () {
              _resetGame();
              _displaySnack(msg: 'Game Restarted');
            }),
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
              title: Text("Winner"),
              content: Image.asset(
                tileState == TileState.CROSS ? 'images/x.png' : 'images/o.png',
              ),
              actions: [
                FlatButton(
                    onPressed: () {
                      _resetGame();
                      Navigator.of(context).pop();
                      _displaySnack(
                          msg: 'NewGame Started', gravity: ToastGravity.CENTER);
                    },
                    child: Text('New Game'))
              ],
            );
          } else {
            return AlertDialog(
              title: Text("Winner"),
              content: Image.asset(
                tileState == TileState.CROSS ? 'images/x.png' : 'images/o.png',
              ),
              actions: [
                FlatButton(
                    onPressed: () {
                      _resetGame();
                      Navigator.of(context).pop();
                      _displaySnack(
                          msg: 'NewGame Started', gravity: ToastGravity.CENTER);
                    },
                    child: Text('New Game'))
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
              title: Text("RESULT"),
              content: Image.asset(
                'images/tie.png',
                color: isDark ? null : Colors.black,
              ),
              actions: [
                FlatButton(
                    onPressed: () {
                      _resetGame();
                      Navigator.of(context).pop();
                      _displaySnack(
                          msg: 'NewGame Started', gravity: ToastGravity.CENTER);
                    },
                    child: Text('New Game'))
              ],
            );
          } else {
            return AlertDialog(
              title: Text("RESULT"),
              content: Image.asset(
                'images/tie.png',
                color: isDark ? null : Colors.black,
              ),
              actions: [
                FlatButton(
                    onPressed: () {
                      _resetGame();
                      Navigator.of(context).pop();
                      _displaySnack(
                          msg: 'NewGame Started', gravity: ToastGravity.CENTER);
                    },
                    child: Text('New Game'))
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
