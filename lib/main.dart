import 'dart:async';

import 'package:flutter/material.dart';

import 'constants.dart';
import 'game.dart';
import 'game_pad.dart';
import 'snake_canvas.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Game _game;

  Scene _scene;

  StreamSubscription _gameSubscription;

  @override
  void initState() {
    super.initState();
    _game = Game();
    _gameSubscription = _game.createGame().listen((scene) {
      print(scene);
      setState(() {
        _scene = scene;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _gameSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 100),
              alignment: Alignment.topCenter,
              child: Snake(_scene, Size(GAME_WIDTH_PIXEL, GAME_HEIGHT_PIXEL)),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: 100),
              child: GamePad(
                onKeyDownEvent: (logicalKeyboardKey) {
                  _game.keyDownController.add(logicalKeyboardKey);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
