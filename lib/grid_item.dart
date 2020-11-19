import 'package:flutter/material.dart';

import 'grid.dart';

class GridItem extends StatelessWidget {

  const GridItem({Key key, @required this.grid}): super(key: key);

  final Grid grid;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(grid.isLandmine ? "1" : "0")
      ],
    );
  }

}