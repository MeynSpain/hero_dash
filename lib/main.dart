import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:hero_dash/game_app.dart';

void main() {
  final GameApp game = GameApp();
  runApp(GameWidget(game: game));
}
