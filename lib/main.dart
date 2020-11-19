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

  final _rowCount = 30,
      _columnCount = 16,
      _landmineCount = 81;

  List<Grid> _grids;
  final Set<int> _landmines = Set();

  @override
  void initState() {
    super.initState();
    _generateLandmines();
    _generateGrids();
  }

  void _generateLandmines() {
    do {
      _landmines.add(Random.secure().nextInt(_rowCount * _columnCount));
    } while (_landmines.length < _landmineCount);
  }

  void _generateGrids() {
    List<Grid> list = List(_rowCount * _columnCount);
    for (int i = 0; i < _rowCount * _columnCount; i++) {
      final rowIndex = i / _columnCount;
      final columnIndex = i % _columnCount;
      var aroundCount = 0;
      //top left
      if (rowIndex > 0 && columnIndex > 0 && _landmines.contains(i - _columnCount - 1)) ++aroundCount;
      //top
      if (rowIndex > 0 && _landmines.contains(i - _columnCount)) ++aroundCount;
      //top right
      if (rowIndex > 0 && columnIndex + 1 < _columnCount && _landmines.contains(i - _columnCount + 1)) ++aroundCount;
      //left
      if (columnIndex > 0 && _landmines.contains(i - 1)) ++aroundCount;
      //right
      if (columnIndex + 1 < _columnCount && _landmines.contains(i + 1)) ++aroundCount;
      //bottom left
      if (rowIndex + 1 < _rowCount && columnIndex > 0 && _landmines.contains(i + _columnCount - 1)) ++aroundCount;
      //bottom
      if (rowIndex + 1 < _rowCount && _landmines.contains(i + _columnCount)) ++aroundCount;
      //bottom right
      if (rowIndex + 1 < _rowCount && columnIndex + 1 < _columnCount && _landmines.contains(i + _columnCount)) ++aroundCount;
      list[i] = Grid(
        landCountAround: aroundCount,
        isLandmine: _landmines.contains(i)
      );
    }
    setState(() {
      _grids = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: _columnCount,
        padding: EdgeInsets.all(2),
        children: _grids.map((e) => GridItem(grid: e)).toList(),
      ),
    );
  }
}
