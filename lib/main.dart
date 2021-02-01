import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';
import 'game.dart';
import 'game_canvas.dart';
import 'game_pad.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Game _game;

  Scene _scene;

  bool _isGameOver = false;

  StreamSubscription _gameSubscription;

  @override
  void initState() {
    super.initState();
    start();
    RawKeyboard.instance.addListener(_rawKeyEvent);
  }

  void start() {
    _game = Game();
    _gameSubscription = _game.createGame().listen((scene) {
      print(scene);
      setState(() {
        _isGameOver = false;
        _scene = scene;
      });
    }, onDone: () {
      setState(() {
        _isGameOver = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _gameSubscription.cancel();
    RawKeyboard.instance.removeListener(_rawKeyEvent);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 100),
              alignment: Alignment.topCenter,
              child: SnakeGameWidget(_scene, _isGameOver,
                  const Size(GAME_WIDTH_PIXEL, GAME_HEIGHT_PIXEL)),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.only(bottom: 100),
              child: GamePad(
                onKeyDownEvent: _onKeyDownEvent,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _rawKeyEvent(RawKeyEvent rawKeyEvent) {
    _onKeyDownEvent(rawKeyEvent.logicalKey);
  }

  void _onKeyDownEvent(LogicalKeyboardKey logicalKeyboardKey) {
    if (!_game.keyDownController.isClosed) {
      _game.keyDownController.add(logicalKeyboardKey);
    } else {
      //游戏结束后任意按键重新开始游戏
      start();
    }
  }
}
