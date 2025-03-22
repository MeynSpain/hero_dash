import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:hero_dash/components/obstacle/enemy_obstacle/enemy_obstacle.dart';

class AttackComponent extends RectangleComponent with CollisionCallbacks {
  final int damage;
  final double knockBackRange;
  bool isActivate = false;

  bool splash;

  // Для атаки одного противника
  bool hasDealtDamage = false;

  final Set<EnemyObstacle> hitEnemies = {};

  AttackComponent({
    required this.damage,
    required this.knockBackRange,
    required super.size,
    required super.position,
    this.splash = true,
  }) : super(anchor: Anchor.centerLeft);

  @override
  FutureOr<void> onLoad() {
    paint.color = Color.fromRGBO(255, 255, 1, 1);
    add(RectangleHitbox(isSolid: true));

    return super.onLoad();
  }

  // @override
  // void onCollisionStart(
  //   Set<Vector2> intersectionPoints,
  //   PositionComponent other,
  // ) {
  //   super.onCollisionStart(intersectionPoints, other);
  //
  //   if (isActivate && other is EnemyObstacle) {
  //     print('Атака из компонента атаки');
  //     other.takeDamage(damage);
  //     other.knockBack(knockBackRange);
  //   }
  // }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (splash) {
      _splashAttack(other);
    } else {
      _singleAttack(other);
    }
  }

  void _splashAttack(PositionComponent other) {
    if (isActivate && other is EnemyObstacle) {
      if (!hitEnemies.contains(other)) {
        hitEnemies.add(other);
        other.takeDamage(damage);
        other.knockBack(knockBackRange);
      }
    }
  }

  void _singleAttack(PositionComponent other) {
    if (isActivate && !hasDealtDamage && other is EnemyObstacle) {
      hasDealtDamage = true;
      hitEnemies.add(other);
      other.takeDamage(damage);
      other.knockBack(knockBackRange);
    }
  }

  void activate() {
    isActivate = true;
    Future.delayed(Duration(milliseconds: 200), () {
      isActivate = false;

      if (splash) {
        hitEnemies.clear();
      } else {
        hasDealtDamage = false;
      }
    });
  }
}
