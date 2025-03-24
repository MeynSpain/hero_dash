import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:hero_dash/components/displays/health_display.dart';
import 'package:hero_dash/components/obstacle/enemy_obstacle/enemy_obstacle.dart';
import 'package:hero_dash/components/obstacle/enemy_obstacle/test_enemy.dart';
import 'package:hero_dash/components/obstacle/object_obstacle/object_obstacle.dart';
import 'package:hero_dash/components/obstacle/object_obstacle/test_rock.dart';
import 'package:hero_dash/components/obstacle/obstacle.dart';
import 'package:hero_dash/components/player.dart';

class GameApp extends FlameGame with DragCallbacks, HasCollisionDetection {
  late final Player player;
  late final SpawnComponent _obstacleSpawner;
  late final HealthDisplay healthDisplay;

  // Тест для деша
  final List<Obstacle> movingObstacles = [];

  // Свайп
  Vector2? _startPosition;
  Vector2? _endPosition;

  @override
  Future<void> onLoad() async {
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();

    debugMode = true;

    startGame();

    return super.onLoad();
  }

  void startGame() {
    _createPlayer();
    _createHealthDisplay();
    _createObstacleSpawner();
    _createDebugComponents();
  }

  void _createPlayer() {
    player = Player(position: Vector2(100, size.y - 10));

    add(player);
  }

  void _createHealthDisplay() {
    healthDisplay = HealthDisplay(position: Vector2(20, 20));

    player.subscribeHealthObserver(healthDisplay);

    add(healthDisplay);
  }

  void _createDebugComponents() {
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

    // add(
    //   TestRock(
    //     speed: 200,
    //     health: 3,
    //     maxHealth: 3,
    //     size: Vector2.all(50),
    //     position: Vector2(20, 20),
    //   ),
    // );
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  void playerDied() {
    // pauseEngine();
  }

  void _createObstacleSpawner() {
    // TODO: Нужно сделать нормальные спавнеры, а этот метод вообще удалить
    Random random = Random();
    _obstacleSpawner = SpawnComponent.periodRange(
      factory: (index) {
        final Obstacle obstacle;

        if (random.nextInt(2) >= 1) {
          obstacle = TestEnemy(
            speed: 200,
            health: 3,
            maxHealth: 3,
            size: Vector2(50, 75),
            position: Vector2(size.x + 10, player.y),
          );

          movingObstacles.add(obstacle);

          return obstacle as EnemyObstacle;
        } else {
          obstacle = TestRock(
              speed: 200,
              health: 3,
              maxHealth: 3,
              size: Vector2.all(50),
              position: Vector2(size.x + 10, player.y - 25),
            );


          movingObstacles.add(obstacle);

          return obstacle as ObjectObstacle;
        }
        // final enemy = TestEnemy(
        //   speed: 200,
        //   health: 3,
        //   maxHealth: 3,
        //   size: Vector2(50, 75),
        //   position: Vector2(size.x + 10, player.y),
        // );

        // movingObstacles.add(obstacle);
        // // print('size : ${movingObstacles.length}\n$movingObstacles');
        // return obstacle;
      },
      //     TestRock(
      //   speed: 200,
      //   health: 3,
      //   maxHealth: 3,
      //   size: Vector2.all(50),
      //   position: Vector2(size.x + 10, player.y - 25),
      // ),
      // Obstacle1(position: Vector2(size.x + 10, player.y)),
      minPeriod: 1.0,
      maxPeriod: 2.0,
      selfPositioning: true,
    );
    add(_obstacleSpawner);
  }

  void removeFromGame(Obstacle obstacle) {
    movingObstacles.remove(obstacle);
  }

  void activateDash(double dashSpeedMultiplier, Duration duration) {
    for (var obstacle in movingObstacles) {
      print('Obstacle old speed: ${obstacle.velocity}');
      obstacle.updateSpeed(obstacle.speed * dashSpeedMultiplier);
      print('Obstacle new speed: ${obstacle.velocity}');
    }

    Future.delayed(duration, () {
      for (var obstacle in movingObstacles) {
        obstacle.updateSpeed(obstacle.speed);
        print(
          'Obstacle Обновилась speed: ${obstacle.velocity}',
        );
      }
    });
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);

    if (event.localPosition.x < size.x / 2) {
      player.jump();
      player.startGliding();
      _startPosition = event.localPosition;
    }

    if (event.localPosition.x > size.x / 2) {
      print('Attack');
      player.attack();
    }
  }



  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (event.localStartPosition.x < size.x / 2) {
      // player.startGliding();
    }
    _endPosition = event.localStartPosition;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _swipe();
    player.stopGliding();

  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);

    player.stopGliding();
  }

  void _swipe() {
    if (_startPosition != null && _endPosition != null) {
      final swipeDirection = _endPosition! - _startPosition!;

      // Горизонтальный ли свайп
      if (swipeDirection.x.abs() > swipeDirection.y.abs()) {
        if (swipeDirection.x.abs() >= 50) {
          player.dash();
        }
      }
    }

    _startPosition = null;
    _endPosition = null;
  }
}
