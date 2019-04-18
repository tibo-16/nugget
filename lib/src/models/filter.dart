import 'package:flutter/material.dart';

class Filter {
  bool isActive;
  bool isLeft;

  double x;
  BorderRadiusGeometry borderRadius;
  double opacity;
  String name;

  Filter({@required this.isActive, @required this.isLeft}) {
    updateFields(isActive: isActive, isLeft: isLeft);
  }

  updateFields({@required bool isActive, @required bool isLeft}) {
    this.isActive = isActive;
    this.isLeft = isLeft;

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

  static Filter from(Filter filter) {
    Filter newFilter = Filter(isActive: filter.isActive, isLeft: filter.isLeft);
    newFilter.updateFields(isActive: filter.isActive, isLeft: filter.isLeft);

    return newFilter;
  }
}
