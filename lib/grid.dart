import 'package:flutter/material.dart';

class Grid {
  const Grid(
      {@required this.landCountAround,
      @required this.isLandmine,
      this.status = GridStatus.NORMAL});

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
    return "around: " +
        landCountAround.toString() +
        "  isLandmine: " +
        isLandmine.toString() +
        "  status: " +
        status.toString();
  }
}

enum GridStatus { NORMAL, CONFIRM, FLAG, DOUBT }
