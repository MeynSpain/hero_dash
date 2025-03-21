import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:hero_dash/components/obstacle/object_obstacle/object_obstacle.dart';
import 'package:hero_dash/game_app.dart';

class TestRock extends ObjectObstacle with HasGameReference<GameApp> {
  final double _spinSpeed = -1.5;

  TestRock({
    required super.speed,
    required super.health,
    required super.maxHealth,
    required super.size,
    required super.position,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await game.loadSprite('debug_sprite.png');
    print('OnLoad в TestRock');
  }

  @override
  void addHitBox() {
    add(CircleHitbox());
  }

  @override
  void move(double dt) {
    super.move(dt);
    position.x -= speed * dt;
    _rotateUpdate(dt);
  }

  void _rotateUpdate(double dt) {
    angle += _spinSpeed * dt;
  }

  @override
  void takeDamage(int value) {
    // TODO: implement takeDamage
  }
}
