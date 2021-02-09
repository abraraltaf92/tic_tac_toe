import 'dart:math';

enum TileState { EMPTY, CROSS, CIRCLE }

// building list of list --> [1,2,3,4,5,6,7,8,9] => [ [1,2,3] [4,5,6] [7,8,9] ]

// size always gonna be 3 here just for generality
List<List<TileState>> chunk(List<TileState> list, int size) {
  return List.generate(
      (list.length / size).ceil(),
      (index) => list.sublist(index * size,
          min(index * size + size, list.length)) // explained below

      );
  //also here we are returning a list only we'll convert it into widget later
  // ceil for approx double
}

// this method is used for the sake of generality, again:
// this method is effective when there isn't perfect division of
// list.lentgh /size e.g if size = 2 and list.length = 9 how to sublist?
// [[1,2] [3,4] [5,6] [7,8] ] here 9 is left (becz due to math function
// used "min()".
