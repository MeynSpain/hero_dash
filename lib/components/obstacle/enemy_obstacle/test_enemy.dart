import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:hero_dash/components/obstacle/enemy_obstacle/enemy_obstacle.dart';
import 'package:hero_dash/game_app.dart';

class TestEnemy extends EnemyObstacle with HasGameReference<GameApp> {
  late Vector2 _velocity;
  final Vector2 _originalVelocity = Vector2.zero();

  TestEnemy({
    required super.speed,
    required super.health,
    required super.maxHealth,
    required super.size,
    required super.position,
  }) {
    paint.color = Color.fromRGBO(1, 1, 255, 1);
    anchor = Anchor.bottomCenter;
    _velocity = Vector2(-1 * speed, 0);
    _originalVelocity.setFrom(_velocity);
  }

  @override
  void update(double dt) {
    super.update(dt);

    move(dt);
  }

  @override
  void move(double dt) {
    position += _velocity * dt;
    super.move(dt);
  }

  @override
  void death() {
    removeFromParent();
  }

  @override
  void addHitBox() {
    add(RectangleHitbox());
  }

  /* Перенес эту логику в EnemyObstacle
   @override
  void knockBack(double range) {
    print('KnockBack');
    _applyKnockBack(range);
  }

  void _applyKnockBack(double range) {
    _velocity.setZero();

    print('Apply KnockBack');
    final MoveByEffect knockBackEffect = MoveByEffect(
      Vector2(range, 0),
      EffectController(duration: 0.5),
      onComplete: _restoreVelocity,
    );

    add(knockBackEffect);
  }

  void _restoreVelocity() {
    _velocity.setFrom(_originalVelocity);
  }
   */

  void _flashWhite() {
    final flashEffect = ColorEffect(
      const Color.fromRGBO(255, 255, 255, 1),
      EffectController(duration: 0.1, alternate: true),
    );
    add(flashEffect);
  }
}
