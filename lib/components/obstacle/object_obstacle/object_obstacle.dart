import 'dart:async';

import 'package:flame/components.dart';
import 'package:hero_dash/components/obstacle/obstacle.dart';

abstract class ObjectObstacle extends SpriteComponent implements Obstacle {
  @override
  final double speed;

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
  }) : super(anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    addHitBox();

    print('Сработал onLoad в ObjectObstacle');
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
    if (position.x <= -size.x / 2) {
      removeFromParent();
    }
  }

  @override
  void takeDamage(int value);
}
