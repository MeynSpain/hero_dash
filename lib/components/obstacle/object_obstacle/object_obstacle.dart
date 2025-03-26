import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:hero_dash/components/obstacle/obstacle.dart';
import 'package:hero_dash/game_app.dart';

abstract class ObjectObstacle extends SpriteComponent implements Obstacle {
  @override
  double speed;

  @override
  int health;

  @override
  final int maxHealth;

  ObjectObstacle({
    required this.speed,
    required this.health,
    required this.maxHealth,
    required super.size,
    required super.position,
  }) : super(anchor: Anchor.center) {
    velocity = Vector2(-1, 0) * speed;
  }

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    addHitBox();
  }

  @override
  void update(double dt) {
    super.update(dt);
    move(dt);
  }

  /// Вызывается в методе onLoad
  void addHitBox();

  /// По умолчанию объект удаляется если он вышел за левый край экрана
  @override
  void move(double dt) {
    // print('ABs: $absolutePosition');
    // print('Pos: $position');
    position += velocity * dt;
    if (absolutePosition.x <= -size.x / 2) {
      removeFromGame();
    }
  }

  @override
  void takeDamage(int value) {
    health = max(health - value, 0);
  }

  @override
  void updateSpeed(double newSpeed) {
    velocity = velocity.normalized() * newSpeed;
  }

  @override
  void removeFromGame() {
    print('Удалено препятствие');
    removeFromParent();
    if (parent is GameApp) {
      (parent as GameApp).removeFromGame(this);
    }
  }
}
