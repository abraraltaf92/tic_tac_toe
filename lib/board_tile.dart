import 'package:flutter/material.dart';
import 'package:tic_tac_toe/tile_state.dart';

class BoardTile extends StatelessWidget {
  final TileState tileState;
  final double dimension;
  final VoidCallback onPressed;
  BoardTile({this.dimension, this.onPressed, this.tileState});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: dimension,
      width: dimension,
      child: FlatButton(
        child: _widgetForTileState(),
        onPressed: onPressed,
      ),
    );
  }

  Widget _widgetForTileState() {
    Widget widget;
    switch (tileState) {
      case TileState.EMPTY:
        widget = Container();

        break;
      case TileState.CROSS:
        widget = Image.asset(
          'images/x.png',
          scale: 0.5,
        );
        break;
      case TileState.CIRCLE:
        widget = Image.asset(
          'images/o.png',
        );
        break;
    }
    return widget;
  }
}
