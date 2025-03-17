import 'dart:developer';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:hero_dash/game_app.dart';

class Obstacle extends RectangleComponent with HasGameReference<GameApp> {
  final double speed = 100;

  Obstacle({required super.position})
    : super(
        paint: Paint()..color = Color.fromRGBO(255, 165, 0, 1),
        size: Vector2.all(50),
        anchor: Anchor.bottomCenter,
      );

  @override
  void update(double dt) {
    super.update(dt);

    _move(dt);
  }

  void _move(double dt) {
    position.x -= speed * dt;

    if (position.x <= -size.x / 2) {
      removeFromParent();
      log('Obstacle removed');
    }
  }
}
