import 'package:flutter/material.dart';

class Grid {
  const Grid(
      {@required this.index,
      @required this.landCountAround,
      @required this.isLandmine,
      this.status = GridStatus.NORMAL});

  final int index;
  final int landCountAround;
  final bool isLandmine;
  final GridStatus status;

  IconData getIconData() {
    switch (status) {
      case GridStatus.NORMAL:
        return null;
      case GridStatus.CONFIRM:
        return isLandmine ? Icons.coronavirus : null;
      case GridStatus.FLAG:
        return Icons.golf_course;
      case GridStatus.DOUBT:
        return Icons.help_outline;
    }
    return null;
  }

  @override
  String toString() {
    return "index: " +
        index.toString() +
        "around: " +
        landCountAround.toString() +
        "  isLandmine: " +
        isLandmine.toString() +
        "  status: " +
        status.toString();
  }
}

enum GridStatus { NORMAL, CONFIRM, FLAG, DOUBT }
