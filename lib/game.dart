import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import 'constants.dart';

class Game {
  Stream<LogicalKeyboardKey> _keyDown$;
  Stream<int> _ticks$;

  StreamController<LogicalKeyboardKey> keyDownController;

  Game() {
    keyDownController = _keyDown();
    _keyDown$ = keyDownController.stream;
    _ticks$ = _ticks();
  }

  Stream<LogicalKeyboardKey> createGame() {
    return _ticks$.withLatestFrom(_keyDown$, (_, LogicalKeyboardKey key) {
      return key;
    });
  }

  void dispose() {
    keyDownController.close();
  }

  static Stream<int> _ticks() {
    return Stream.periodic(Duration(milliseconds: TICKS_TICKS),
        (computationCount) => computationCount);
  }

  static StreamController<LogicalKeyboardKey> _keyDown() {
    var controller = StreamController<LogicalKeyboardKey>();
    return controller;
  }
}
