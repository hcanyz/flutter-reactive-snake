import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_snake/constants.dart';

import 'game.dart';

class SnakeGameWidget extends StatefulWidget {
  final Scene _scene;
  final bool _isGameOver;
  final Size _size;

  SnakeGameWidget(this._scene, this._isGameOver, this._size);

  @override
  _SnakeGameWidgetState createState() => _SnakeGameWidgetState();
}

class _SnakeGameWidgetState extends State<SnakeGameWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget._size,
      painter: _Paint(widget._scene, widget._isGameOver),
    );
  }
}

class _Paint extends CustomPainter {
  Scene _scene;
  bool _isGameOver;
  Paint _paint = Paint();

  _Paint(this._scene, this._isGameOver);

  @override
  void paint(Canvas canvas, Size size) {
    //背景
    _paint.color = Colors.blue;
    canvas.drawRect(Offset.zero & size, _paint);

    if (_isGameOver) {
      //游戏结束
      TextSpan span =
          new TextSpan(text: "game over!", style: TextStyle(color: Colors.red));
      TextPainter tp = new TextPainter(
          text: span,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center);
      tp.layout();
      tp.paint(
          canvas,
          new Offset(
              size.width / 2 - tp.width / 2, size.height / 2 - tp.height / 2));
      return;
    }

    if (_scene == null) return;

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
    return !_isGameOver;
  }
}
