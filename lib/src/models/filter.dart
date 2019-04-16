import 'package:flutter/material.dart';

class Filter {
  final bool isActive;
  final bool isLeft;

  double x;
  BorderRadiusGeometry borderRadius;
  double opacity;
  String name;

  Filter({@required this.isActive, @required this.isLeft}) {
    isLeft
        ? borderRadius = BorderRadius.only(
            topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0))
        : borderRadius = BorderRadius.only(
            topRight: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0));

    isLeft ? x = -1 : x = 1;

    isLeft ? name = 'Jenny' : name = 'Tobi';

    isActive ? opacity = 1.0 : opacity = 0.0;
  }
}
