import 'package:flutter/material.dart';
import 'package:flutter_mine_sweeper/functions.dart';

import 'grid.dart';

class GridItem extends StatelessWidget {
  const GridItem(
      {Key key,
      @required this.grid,
      @required this.onClick,
      @required this.onLongClick,
      @required this.index})
      : super(key: key);

  final Grid grid;
  final IntCallback onClick;
  final IntCallback onLongClick;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: [
          Container(
            color: grid.status == GridStatus.CONFIRM
                ? Colors.greenAccent
                : Colors.blue,
          ),
          Center(child: Icon(grid.getIconData())),
          Center(
              child: Text(grid.status == GridStatus.CONFIRM &&
                      !grid.isLandmine &&
                      grid.landCountAround != 0
                  ? grid.landCountAround.toString()
                  : "")),
        ],
      ),
      onLongPress: () {
        if (grid.status != GridStatus.CONFIRM) onLongClick(index);
      },
      onTap: () {
        if (grid.status == GridStatus.NORMAL) onClick(index);
      },
    );
  }
}
