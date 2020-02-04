import 'dart:math';

//🐍状态刷新间隔
const int TICKS_TICKS = 200;

//🐍的初始值
const List<Point<int>> SNAKE_INIT = [Point(0, 0), Point(1, 0), Point(2, 0)];

//🍎的初始值
const List<Point<int>> APPLE_INIT = [
  Point(11 % GAME_HEIGHT, 11 % GAME_HEIGHT),
  Point(55 % GAME_WIDTH, 55 % GAME_HEIGHT)
];

//游戏界面虚拟宽高
const int GAME_WIDTH = 60;
const int GAME_HEIGHT = 60;

const double GAME_PIXEL_SIZE = 5.0;
//游戏界面像素宽高
const double GAME_WIDTH_PIXEL = GAME_WIDTH * GAME_PIXEL_SIZE;
const double GAME_HEIGHT_PIXEL = GAME_HEIGHT * GAME_PIXEL_SIZE;
