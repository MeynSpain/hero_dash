import 'dart:async';

import 'package:flame/components.dart';
import 'package:hero_dash/components/obstacle/object_obstacle/test_rock.dart';
import 'package:hero_dash/components/obstacle/obstacle.dart';
import 'package:hero_dash/game_app.dart';

abstract class GroupObstacle extends PositionComponent {
  double speed;
  late Vector2 velocity;

  GroupObstacle({required this.speed}) : super(anchor: Anchor.bottomCenter) {
    velocity = Vector2(-1, 0) * speed;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    await loadObstacles();
  }

  @override
  void update(double dt) {
    super.update(dt);

    move(dt);
  }

  void move(double dt) {
    position += velocity * dt;
    if (children.isEmpty) {
      print('Удаляется Группа препятствий');
      removeFromGame();
    }
    // if (position.x <= -1000) {
    //   removeFromParent();
    // }
  }

  // void removeChildrenUpdate(double dt) {
  //   children.removeWhere((child) {
  //     if (child is PositionComponent) {
  //
  //     }
  //   });
  // }

  FutureOr<void> loadObstacles();

  void updateSpeed(double newSpeed) {
    velocity = velocity.normalized() * newSpeed;
  }

  Vector2 getAbsolutePosition(PositionComponent child) {
    Vector2 absolutePosition = child.position.clone();
    var currentParent = parent;

    while (currentParent != null) {
      if (currentParent is PositionComponent) {
        absolutePosition += currentParent.position;
      }
      currentParent = currentParent.parent;
    }

    return absolutePosition;
  }

  void removeFromGame() {
    removeFromParent();
    if (parent is GameApp) {
      (parent as GameApp).movingGroupObstacles.remove(this);
    }
  }
}
