import 'dart:async';

import 'package:flame/components.dart';
import 'package:hero_dash/components/group_obstacles/group_obstacle.dart';
import 'package:hero_dash/components/obstacle/enemy_obstacle/test_enemy.dart';
import 'package:hero_dash/components/obstacle/object_obstacle/test_rock.dart';

class TestGroup extends GroupObstacle {
  TestGroup({required super.speed});

  @override
  FutureOr<void> loadObstacles() {
    final rock = TestRock(
      speed: 0,
      health: 3,
      maxHealth: 3,
      size: Vector2.all(50),
      position: Vector2(0, 0),
    );

    final enemy = TestEnemy(
      speed: 0,
      health: 3,
      maxHealth: 3,
      size: Vector2(50, 75),
      position: Vector2(75, 0),
    );

    add(rock);
    add(enemy);
  }

}