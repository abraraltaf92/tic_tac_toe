import 'package:flutter/material.dart';

class Config {
  static double xDimension(BuildContext context, double width) {
    double screenWidth = MediaQuery.of(context).size.width;
    return width * screenWidth / 100;
  }

  static double yDimension(BuildContext context, double height) {
    double screenHeight = MediaQuery.of(context).size.height;
    return height * screenHeight / 100;
  }
}
