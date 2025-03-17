import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:hero_dash/components/obstacle.dart';
import 'package:hero_dash/components/player.dart';

class GameApp extends FlameGame with TapCallbacks {
  late final Player player;
  late final SpawnComponent _obstacleSpawner;

  @override
  Future<void> onLoad() async {
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();

    player = Player(position: Vector2(100, size.y - 10));

    add(player);

    add(
      RectangleComponent(
        paint: Paint()..color = Color.fromRGBO(1, 255, 1, 1),
        position: Vector2(100, size.y - 10),
        size: Vector2(100, 2),
      ),
    );

    add(
      RectangleComponent(
        paint: Paint()..color = Color.fromRGBO(1, 255, 1, 1),
        position: Vector2(100, size.y / 2),
        size: Vector2(100, 2),
      ),
    );

    add(TextComponent(text: 'Game', position: Vector2(size.x / 2, size.y / 2)));

    _createObstacleSpawner();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);

    player.jump();
  }

  void _createObstacleSpawner() {
    _obstacleSpawner = SpawnComponent.periodRange(
      factory: (index) => Obstacle(position: Vector2(size.x + 10, player.y)),
      minPeriod: 1.0,
      maxPeriod: 2.0,
      selfPositioning: true,
    );
    add(_obstacleSpawner);
  }
}
