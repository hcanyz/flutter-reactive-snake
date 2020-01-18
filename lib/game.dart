import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';
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
    //初始化一个右箭头事件
    Stream<Map<String, int>> _direction$ = keyDownController.stream
        .startWith(LogicalKeyboardKey.arrowRight)
        .map((key) {
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

    var _snackEatApple = BehaviorSubject<Point>.seeded(null);

    var _snackEatApple$ =
        _snackEatApple.scan((Point acc, Point value, int index) {
      if (acc == value) {
        return null;
      }
      return value;
    });

    //🐍的状态 = 当前位置 + 方向 + 吃🍎事件 随时间更新
    Stream<Queue<Point>> _snack$ = _ticks$
        //每隔一段时间产生一个方向移动事件
        //如果🐍长度发生变化，也要更新
        .withLatestFrom2(_direction$, _snackEatApple$,
            (_, Map<String, int> change, Point eatApple) {
      return [change, eatApple];
    }).scan((Queue<Point> snack, List<dynamic> factor, index) {
      //根据移动事件和当前位置、吃🍎事件，更新🐍的状态
      Map<String, int> direction = factor[0];
      Point eatApple = factor[1];
      if (eatApple == null) {
        snack.removeFirst();
        Point last = snack.last;
        snack.addLast(Point((last.x + direction["x"]) % GAME_WIDTH,
            (last.y + direction["y"]) % GAME_HEIGHT));
      } else {
        snack.addLast(eatApple);
      }
      return snack;
    }, ListQueue<Point>.from(SNACK_INIT)).share();

    //🍎的状态
    Stream<List<Point>> _$apple =
        _snack$.scan((List<Point> apple, Queue<Point> snack, int index) {
      var appleN = List<Point>.from(apple);
      for (var value in apple) {
        if (snack.contains(value)) {
          //🐍接触到🍎，则生成新到🍎，新🍎不会生成到老位置和🐍到位置上
          appleN.remove(value);
          Point newApple;
          do {
            newApple = Point(
                Random().nextInt(GAME_WIDTH), Random().nextInt(GAME_HEIGHT));
          } while (newApple == value || snack.contains(newApple));
          appleN.add(newApple);
          //发送一个🐍吃🍎事件
          _snackEatApple.add(value);
          break;
        }
      }
      return appleN;
    }, APPLE_INIT).distinct((List<Point> a1, List<Point> a2) {
      return listEquals(a1, a2);
    }).share();

    //游戏分数，🐍的长度就是游戏的分数
    Stream<int> _score$ = _$apple
        .map((snack) {
          return snack.length;
        })
        .distinct()
        .scan((int score, int value, int index) {
          return score + 1;
        }, -1);

    return Rx.combineLatest3(_snack$, _$apple, _score$,
        (Queue<Point> snack, List<Point> apple, int score) {
      return Scene(snack, apple, score);
    }).doOnCancel(() {
      _snackEatApple.close();
      keyDownController.close();
    });
  }
}

class Scene {
  Queue<Point> snack;
  List<Point> apple;
  int score;

  Scene(this.snack, this.apple, this.score);

  @override
  String toString() {
    return 'Scene{snack: $snack, apple: $apple, score: $score}';
  }
}
