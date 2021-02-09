import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/board_tile.dart';
import 'package:tic_tac_toe/tile_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorkey = GlobalKey<NavigatorState>();
  var _boardState = List<TileState>.filled(9, TileState.EMPTY);
  var _currentState = TileState.CROSS; //since Cross goes the first
  int countDraw = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorkey,
      title: 'Tic Tac Toe',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tic Tac Toe'),
        ),
        body: SafeArea(
          child: Center(
            child: Stack(
              children: <Widget>[
                Image.asset(
                  'images/board.png',
                  color: Colors.white54,
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
          onPressed: _resetGame,
        ),
      ),
    );
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
    final newContext = navigatorkey.currentState.overlay.context;
    showDialog(
        context: newContext,
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
                      Navigator.of(newContext).pop();
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
                      Navigator.of(newContext).pop();
                    },
                    child: Text('New Game'))
              ],
            );
          }
        });
  }

  void _showDrawDialog() {
    final newContext = navigatorkey.currentState.overlay.context;
    showDialog(
        context: newContext,
        builder: (_) {
          if (Platform.isIOS) {
            return CupertinoAlertDialog(
              title: Text("RESULT"),
              content: Image.asset('images/tie.png'),
              actions: [
                FlatButton(
                    onPressed: () {
                      _resetGame();
                      Navigator.of(newContext).pop();
                    },
                    child: Text('New Game'))
              ],
            );
          } else {
            return AlertDialog(
              title: Text("RESULT"),
              content: Image.asset('images/tie.png'),
              actions: [
                FlatButton(
                    onPressed: () {
                      _resetGame();
                      Navigator.of(newContext).pop();
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
}
