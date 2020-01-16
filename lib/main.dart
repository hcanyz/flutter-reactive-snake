import 'dart:async';

import 'package:flutter/material.dart';

import 'game.dart';
import 'game_pad.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Game _game;

  StreamSubscription _gameSubscription;

  @override
  void initState() {
    super.initState();
    _game = Game();
    _gameSubscription = _game.createGame().listen((event) {
      print(event);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _game.dispose();
    _gameSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: 30),
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
