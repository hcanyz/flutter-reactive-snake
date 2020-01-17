import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import 'constants.dart';

class Game {
  final StreamController<LogicalKeyboardKey> keyDownController =
      StreamController<LogicalKeyboardKey>();

  Stream<Scene> createGame() {
    //数据更新频率流
    Stream<int> _ticks$ = Stream.periodic(Duration(milliseconds: TICKS_TICKS),
        (computationCount) => computationCount);

    //输入按键事件流,根据按键返回一个x,y方向变化值,过滤了不无意义按键，过滤了与当前方向相同的按键
    Stream<Map<String, int>> _direction$ = keyDownController.stream.map((key) {
      if (key == LogicalKeyboardKey.arrowUp) {
        return const {"x": 0, "y": -1};
      } else if (key == LogicalKeyboardKey.arrowDown) {
        return const {"x": 0, "y": 1};
      } else if (key == LogicalKeyboardKey.arrowLeft) {
        return const {"x": -1, "y": 0};
      } else if (key == LogicalKeyboardKey.arrowRight) {
        return const {"x": 1, "y": 0};
      }
      return null;
    }).where((change) {
      return change != null;
    }).distinct();

    //🐍的状态 = 当前位置 + 方向 随时间更新
    Stream<Queue<Point>> _snack$ =
        _ticks$.withLatestFrom(_direction$, (_, Map<String, int> change) {
      //每隔一段时间产生一个方向移动事件
      print(change);
      return change;
    }).scan((Queue<Point> snack, Map<String, int> direction, index) {
      //根据移动事件和当前位置，返回变化后的位置
      return snack;
    }, ListQueue.from(SNACK_INIT));

    return _snack$.map((event) {
      return Scene();
    });
  }

  void dispose() {
    keyDownController.close();
  }
}

class Scene {
  Scene() {}
}
