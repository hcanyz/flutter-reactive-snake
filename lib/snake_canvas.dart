import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_snake/constants.dart';

import 'game.dart';

class Snake extends StatefulWidget {
  final Scene _scene;
  final Size _size;

  Snake(this._scene, this._size);

  @override
  _SnakeState createState() => _SnakeState();
}

class _SnakeState extends State<Snake> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget._size,
      painter: _Paint(widget._scene),
    );
  }
}

class _Paint extends CustomPainter {
  Scene _scene;
  Paint _paint = Paint();

  _Paint(this._scene);

  @override
  void paint(Canvas canvas, Size size) {
    if (_scene == null) return;
    //背景
    _paint.color = Colors.blue;
    canvas.drawRect(Offset.zero & size, _paint);

    //🐍
    _paint.color = Colors.white;
    for (var point in _scene.snake) {
      canvas.drawRect(realPointRect(point), _paint);
    }

    //🍎
    _paint.color = Colors.red;
    for (var point in _scene.apple) {
      canvas.drawRect(realPointRect(point), _paint);
    }

    //分数
    _paint.color = Colors.grey;
    TextSpan span = new TextSpan(
        text: _scene.score.toString(), style: TextStyle(color: Colors.white54));
    TextPainter tp = new TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center);
    tp.layout();
    tp.paint(
        canvas,
        new Offset(
            size.width / 2 - tp.width / 2, size.height / 2 - tp.height / 2));
  }

  Rect realPointRect(Point point) {
    double x = point.x.toDouble();
    double y = point.y.toDouble();
    return Rect.fromPoints(Offset(x * GAME_PIXEL_SIZE, y * GAME_PIXEL_SIZE),
        Offset((x + 1) * GAME_PIXEL_SIZE, (y + 1) * GAME_PIXEL_SIZE));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
