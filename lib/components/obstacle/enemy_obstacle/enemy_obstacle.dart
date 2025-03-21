import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:hero_dash/components/obstacle/obstacle.dart';

/// Абстрактный класс противника. Потом нужно заменить наследование от PositionComponent
/// на SpriteAnimationComponent
abstract class EnemyObstacle extends RectangleComponent implements Obstacle {
  @override
  final double speed;

  @override
  int health;

  @override
  final int maxHealth;

  EnemyObstacle({
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
  void takeDamage(int value) {
    health = max(health - value, 0);

    if (health <= 0) {
      death();
    }
  }

  void knockBack(double range);

  void death();
}
