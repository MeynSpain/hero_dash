import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:hero_dash/components/obstacle/obstacle.dart';
import 'package:hero_dash/game_app.dart';

/// Абстрактный класс противника. Потом нужно заменить наследование от PositionComponent
/// на SpriteAnimationComponent
abstract class EnemyObstacle extends RectangleComponent implements Obstacle {
  @override
  late Vector2 velocity;

  final Vector2 _originalVelocity = Vector2.zero();

  @override
  double speed;

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
  }) : super(anchor: Anchor.center) {
    velocity = Vector2(-1, 0) * speed;
    _originalVelocity.setFrom(velocity);
  }

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
    // print('ABs: $absolutePosition');
    // print('Pos: $position');
    if (absolutePosition.x <= -size.x / 2) {
      removeFromGame();
      // removeFromParent();
    }
  }

  @override
  void takeDamage(int value) {
    health = max(health - value, 0);

    if (health <= 0) {
      death();
    }
  }

  void knockBack(double range) {
    _applyKnockBack(range);
  }

  void _applyKnockBack(double range) {
    velocity.setZero();

    double duration = 0;

    // За каждые 100 пикселей добавляется время на полет
    duration = (range / 100) * 0.15;

    final MoveByEffect knockBackEffect = MoveByEffect(
      Vector2(range, 0),
      EffectController(duration: duration),
      onComplete: _restoreVelocity,
    );

    add(knockBackEffect);
  }

  @override
  void updateSpeed(double newSpeed) {
    velocity = velocity.normalized() * newSpeed;
  }

  void _restoreVelocity() {
    velocity.setFrom(_originalVelocity);
  }

  void death();

  @override
  void removeFromGame() {
    removeFromParent();
    print('Удаление enemy из parent');
  }
}
