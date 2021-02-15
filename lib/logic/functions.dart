import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:tic_tac_toe/tile_state/tile_state.dart';

int countDraw;
var _boardState;
var _currentState;
AudioCache player;
BuildContext context;

void updateTileStateForIndex(
    {@required int selectedIndex,
    @required bool isDark,
    @required bool isSound}) {
  if (_boardState[selectedIndex] == TileState.EMPTY) {
    setState(() {
      _boardState[selectedIndex] = _currentState;
      _currentState =
          _currentState == TileState.CROSS ? TileState.CIRCLE : TileState.CROSS;
    });

    final winner = _findWinner();
    if (winner != null) {
      showWinnerDialog(
          tileState: winner,
          isDark: isDark,
          isSound: isSound,
          context: context,
          player: player);
    } else {
      countDraw += 1;
      if (countDraw == 9) {
        showDrawDialog(
            isDark: isDark, isSound: isSound, player: player, context: context);
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

void showWinnerDialog(
    {@required TileState tileState,
    @required bool isDark,
    @required bool isSound,
    @required BuildContext context,
    @required AudioCache player}) {
  if (isSound) {
    player.play('win.mp3');
  }
  if (Platform.isIOS) {
    showCupertinoDialog(
        context: context,
        builder: (_) {
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
                    resetGame(
                        countDraw: countDraw,
                        boardState: _boardState,
                        currentState: _currentState);
                    Navigator.of(context).pop();
                    displaySnack(
                        msg: 'NewGame Started',
                        gravity: ToastGravity.CENTER,
                        isDark: isDark);
                  },
                  child: const Text('New Game'))
            ],
          );
        });
  } else {
    showDialog(
        context: context,
        builder: (_) {
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
                    resetGame(
                        countDraw: countDraw,
                        currentState: _currentState,
                        boardState: _boardState);
                    Navigator.of(context).pop();
                    displaySnack(
                        msg: 'NewGame Started',
                        gravity: ToastGravity.CENTER,
                        isDark: isDark);
                  },
                  child: const Text('New Game'))
            ],
          );
        });
  }
}

void showDrawDialog(
    {@required bool isDark,
    @required bool isSound,
    @required AudioCache player,
    @required BuildContext context}) {
  if (isSound) {
    player.play('draw.mp3');
  }

  if (Platform.isIOS) {
    showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: const Text("RESULT"),
            content: Image.asset(
              'assets/images/tie.png',
              color: Colors.red,
            ),
            actions: [
              FlatButton(
                  onPressed: () {
                    resetGame(
                        countDraw: countDraw,
                        currentState: _currentState,
                        boardState: _boardState);
                    Navigator.of(context).pop();
                    displaySnack(
                        msg: 'NewGame Started',
                        gravity: ToastGravity.CENTER,
                        isDark: isDark);
                  },
                  child: const Text('New Game'))
            ],
          );
        });
  } else {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("RESULT"),
            content: Image.asset('assets/images/tie.png', color: Colors.red),
            actions: [
              FlatButton(
                  onPressed: () {
                    resetGame(
                        countDraw: countDraw,
                        currentState: _currentState,
                        boardState: _boardState);
                    Navigator.of(context).pop();
                    displaySnack(
                        msg: 'NewGame Started',
                        gravity: ToastGravity.CENTER,
                        isDark: isDark);
                  },
                  child: const Text('New Game'))
            ],
          );
        });
  }
}

void resetGame(
    {@required int countDraw,
    @required TileState currentState,
    @required List<dynamic> boardState}) {
  setState(() {
    boardState = List.filled(9, TileState.EMPTY);
    currentState = TileState.CROSS;
    countDraw = 0;
  });
}

void setState(Null Function() param0) {}

void displaySnack(
    {@required String msg, ToastGravity gravity, @required bool isDark}) {
  Fluttertoast.showToast(
    msg: msg,
    gravity: gravity,
    backgroundColor: isDark ? Colors.black : Colors.grey,
  );
}
