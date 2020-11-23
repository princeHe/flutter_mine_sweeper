import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mine_sweeper/grid.dart';
import 'package:flutter_mine_sweeper/grid_item.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _rowCount = 30, _columnCount = 16, _landmineCount = 81;

  List<Grid> _grids;
  BuildContext context;

  @override
  void initState() {
    super.initState();
    _generateGrids();
  }

  void _generateGrids() {
    final Set<int> _landmines = Set();
    do {
      _landmines.add(Random.secure().nextInt(_rowCount * _columnCount));
    } while (_landmines.length < _landmineCount);
    List<Grid> list = List(_rowCount * _columnCount);
    for (int i = 0; i < _rowCount * _columnCount; i++) {
      final int rowIndex = i ~/ _columnCount;
      final int columnIndex = i % _columnCount;
      var aroundCount = 0;
      //top left
      if (rowIndex > 0 &&
          columnIndex > 0 &&
          _landmines.contains(i - _columnCount - 1)) ++aroundCount;
      //top
      if (rowIndex > 0 && _landmines.contains(i - _columnCount)) ++aroundCount;
      //top right
      if (rowIndex > 0 &&
          columnIndex + 1 < _columnCount &&
          _landmines.contains(i - _columnCount + 1)) ++aroundCount;
      //left
      if (columnIndex > 0 && _landmines.contains(i - 1)) ++aroundCount;
      //right
      if (columnIndex + 1 < _columnCount && _landmines.contains(i + 1))
        ++aroundCount;
      //bottom left
      if (rowIndex + 1 < _rowCount &&
          columnIndex > 0 &&
          _landmines.contains(i + _columnCount - 1)) ++aroundCount;
      //bottom
      if (rowIndex + 1 < _rowCount && _landmines.contains(i + _columnCount))
        ++aroundCount;
      //bottom right
      if (rowIndex + 1 < _rowCount &&
          columnIndex + 1 < _columnCount &&
          _landmines.contains(i + _columnCount + 1)) ++aroundCount;
      list[i] = Grid(
          index: i,
          landCountAround: aroundCount,
          isLandmine: _landmines.contains(i));
    }
    setState(() {
      _grids = list;
    });
  }

  bool _success() {
    return _grids
            .where((element) =>
                !element.isLandmine && element.status == GridStatus.CONFIRM)
            .length ==
        _columnCount * _rowCount - _landmineCount;
  }

  void _onClick(int index) {
    if (_grids[index].isLandmine) {
      //点到了雷
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("祝您下次好运"),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("取消"),
                ),
                MaterialButton(
                  onPressed: () {
                    _generateGrids();
                    Navigator.pop(context);
                  },
                  child: Text("再来一局"),
                ),
              ],
            );
          });
    }
    //确定扫除一个的时候需要自动点开周围雷数量为0的
    if (_grids[index].landCountAround != 0) {
      _confirmOne(index);
    } else if (!_grids[index].isLandmine) {
      _autoScan(index);
    }
  }

  void _onLongClick(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(children: [
            MaterialButton(
              onPressed: () {
                _clear(index);
                Navigator.pop(context);
              },
              child: Text("清除标记"),
            ),
            MaterialButton(
              onPressed: () {
                _flag(index);
                Navigator.pop(context);
              },
              child: Text("标记为雷"),
            ),
            MaterialButton(
              onPressed: () {
                _doubt(index);
                Navigator.pop(context);
              },
              child: Text("不确定"),
            ),
          ]);
        });
  }

  void _onDoubleClick(int index) {
    final int rowIndex = index ~/ _columnCount;
    final int columnIndex = index % _columnCount;
    List<Grid> list = List();
    //top left
    if (rowIndex > 0 && columnIndex > 0) {
      final currentIndex = index - _columnCount - 1;
      list.add(_grids[currentIndex]);
    }
    //top
    if (rowIndex > 0) {
      final currentIndex = index - _columnCount;
      list.add(_grids[currentIndex]);
    }
    //top right
    if (rowIndex > 0 && columnIndex + 1 < _columnCount) {
      final currentIndex = index - _columnCount + 1;
      list.add(_grids[currentIndex]);
    }
    //left
    if (columnIndex > 0) {
      final currentIndex = index - 1;
      list.add(_grids[currentIndex]);
    }
    //right
    if (columnIndex + 1 < _columnCount) {
      final currentIndex = index + 1;
      list.add(_grids[currentIndex]);
    }
    //bottom left
    if (rowIndex + 1 < _rowCount && columnIndex > 0) {
      final currentIndex = index + _columnCount - 1;
      list.add(_grids[currentIndex]);
    }
    //bottom
    if (rowIndex + 1 < _rowCount) {
      final currentIndex = index + _columnCount;
      list.add(_grids[currentIndex]);
    }
    //bottom right
    if (rowIndex + 1 < _rowCount && columnIndex + 1 < _columnCount) {
      final currentIndex = index + _columnCount + 1;
      list.add(_grids[currentIndex]);
    }
    if (list.where((element) => element.status == GridStatus.FLAG).length ==
        _grids[index].landCountAround) {
      list
          .where((element) => element.status == GridStatus.NORMAL)
          .forEach((element) {
        _onClick(element.index);
      });
    }
  }

  void _confirmOne(int index) {
    setState(() {
      _grids[index] = Grid(
          index: index,
          landCountAround: _grids[index].landCountAround,
          isLandmine: _grids[index].isLandmine,
          status: GridStatus.CONFIRM);
      if (_success()) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("恭喜您"),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("取消"),
                  ),
                  MaterialButton(
                    onPressed: () {
                      _generateGrids();
                      Navigator.pop(context);
                    },
                    child: Text("再来一局"),
                  ),
                ],
              );
            });
      }
    });
  }

  void _clear(int index) {
    setState(() {
      _grids[index] = Grid(
          index: index,
          landCountAround: _grids[index].landCountAround,
          isLandmine: _grids[index].isLandmine,
          status: GridStatus.NORMAL);
    });
  }

  void _flag(int index) {
    setState(() {
      _grids[index] = Grid(
          index: index,
          landCountAround: _grids[index].landCountAround,
          isLandmine: _grids[index].isLandmine,
          status: GridStatus.FLAG);
    });
  }

  void _doubt(int index) {
    setState(() {
      _grids[index] = Grid(
          index: index,
          landCountAround: _grids[index].landCountAround,
          isLandmine: _grids[index].isLandmine,
          status: GridStatus.DOUBT);
    });
  }

  void _autoScan(int index) {
    _confirmOne(index);
    if (_grids[index].landCountAround != 0) {
      return;
    }
    final int rowIndex = index ~/ _columnCount;
    final int columnIndex = index % _columnCount;
    //top left
    if (rowIndex > 0 && columnIndex > 0) {
      final currentIndex = index - _columnCount - 1;
      if (_grids[currentIndex].status == GridStatus.NORMAL)
        _autoScan(currentIndex);
    }
    //top
    if (rowIndex > 0) {
      final currentIndex = index - _columnCount;
      if (_grids[currentIndex].status == GridStatus.NORMAL)
        _autoScan(currentIndex);
    }
    //top right
    if (rowIndex > 0 && columnIndex + 1 < _columnCount) {
      final currentIndex = index - _columnCount + 1;
      if (_grids[currentIndex].status == GridStatus.NORMAL)
        _autoScan(currentIndex);
    }
    //left
    if (columnIndex > 0) {
      final currentIndex = index - 1;
      if (_grids[currentIndex].status == GridStatus.NORMAL)
        _autoScan(currentIndex);
    }
    //right
    if (columnIndex + 1 < _columnCount) {
      final currentIndex = index + 1;
      if (_grids[currentIndex].status == GridStatus.NORMAL)
        _autoScan(currentIndex);
    }
    //bottom left
    if (rowIndex + 1 < _rowCount && columnIndex > 0) {
      final currentIndex = index + _columnCount - 1;
      if (_grids[currentIndex].status == GridStatus.NORMAL)
        _autoScan(currentIndex);
    }
    //bottom
    if (rowIndex + 1 < _rowCount) {
      final currentIndex = index + _columnCount;
      if (_grids[currentIndex].status == GridStatus.NORMAL)
        _autoScan(currentIndex);
    }
    //bottom right
    if (rowIndex + 1 < _rowCount && columnIndex + 1 < _columnCount) {
      final currentIndex = index + _columnCount + 1;
      if (_grids[currentIndex].status == GridStatus.NORMAL)
        _autoScan(currentIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text("MineSweeper"),
      ),
      body: GridView.count(
        crossAxisCount: _columnCount,
        padding: EdgeInsets.all(2),
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        children: _grids
            .asMap()
            .entries
            .map((e) => GridItem(
                  grid: e.value,
                  onClick: _onClick,
                  onLongClick: _onLongClick,
                  onDoubleClick: _onDoubleClick,
                  index: e.key,
                ))
            .toList(),
      ),
    );
  }
}
