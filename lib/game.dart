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

    //输入按键事件流,根据按键返回一个x,y方向变化值,过滤了无意义按键，过滤了与当前方向相同的按键
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

    var _snakeEatApple = BehaviorSubject<Point<int>>.seeded(null);

    var _snakeEatApple$ =
        _snakeEatApple.scan((Point<int> acc, Point<int> value, int index) {
      if (acc == value) {
        return null;
      }
      return value;
    });

    //🐍的状态 = 当前位置 + 方向 + 吃🍎事件 随时间更新
    Stream<Queue<Point<int>>> _snake$ = _ticks$
        //每隔一段时间产生一个方向移动事件
        //如果🐍长度发生变化，也要更新
        .withLatestFrom2(_direction$, _snakeEatApple$,
            (_, Map<String, int> change, Point<int> eatApple) {
      return [change, eatApple];
    }).scan((Queue<Point<int>> snake, List<dynamic> factor, index) {
      //根据移动事件和当前位置、吃🍎事件，更新🐍的状态
      Map<String, int> direction = factor[0];
      Point<int> eatApple = factor[1];
      if (eatApple == null) {
        snake.removeFirst();
        Point<int> last = snake.last;
        snake.addLast(Point<int>((last.x + direction["x"]) % GAME_WIDTH,
            (last.y + direction["y"]) % GAME_HEIGHT));
      } else {
        snake.addLast(eatApple);
        //fixme 更好的办法解决吃🍎事件一直循环问题
        _snakeEatApple.add(null);
      }
      return snake;
    }, ListQueue<Point<int>>.from(SNAKE_INIT)).share();

    //🍎的状态
    Stream<List<Point<int>>> _$apple = _snake$.scan(
        (List<Point<int>> apple, Queue<Point<int>> snake, int index) {
      var appleN = List<Point<int>>.from(apple);
      for (var value in apple) {
        if (snake.contains(value)) {
          //🐍接触到🍎，则生成新到🍎，新🍎不会生成到老位置和🐍到位置上
          appleN.remove(value);
          Point<int> newApple;
          do {
            newApple = Point<int>(
                Random().nextInt(GAME_WIDTH), Random().nextInt(GAME_HEIGHT));
          } while (newApple == value || snake.contains(newApple));
          appleN.add(newApple);
          //发送一个🐍吃🍎事件
          _snakeEatApple.add(value);
          break;
        }
      }
      return appleN;
    }, APPLE_INIT).distinct((List<Point<int>> a1, List<Point<int>> a2) {
      return listEquals(a1, a2);
    }).share();

    //游戏分数，🐍的长度就是游戏的分数
    Stream<int> _score$ = _$apple
        .map((snake) {
          return snake.length;
        })
        .distinct()
        .scan((int score, int value, int index) {
          return score + 1;
        }, -1);

    return Rx.combineLatest3(_snake$, _$apple, _score$,
        (Queue<Point<int>> snake, List<Point<int>> apple, int score) {
      return Scene(snake, apple, score);
    }).doOnCancel(() {
      _snakeEatApple.close();
      keyDownController.close();
    });
  }
}

class Scene {
  Queue<Point<int>> snake;
  List<Point<int>> apple;
  int score;

  Scene(this.snake, this.apple, this.score);

  @override
  String toString() {
    return 'Scene{snake: $snake, apple: $apple, score: $score}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Scene &&
          runtimeType == other.runtimeType &&
          snake == other.snake &&
          apple == other.apple &&
          score == other.score;

  @override
  int get hashCode => snake.hashCode ^ apple.hashCode ^ score.hashCode;
}
