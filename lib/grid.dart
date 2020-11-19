
import 'package:flutter/cupertino.dart';

class Grid {

  const Grid({
    @required this.landCountAround,
    @required this.isLandmine,
    this.status = GridStatus.NORMAL
  });

  final int landCountAround;
  final bool isLandmine;
  final GridStatus status;
}

enum GridStatus {
  NORMAL, CONFIRM, FLAG, DOUBT
}