import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:hero_dash/components/obstacle.dart';
import 'package:hero_dash/game_app.dart';
import 'package:hero_dash/observers/health_observer.dart';
import 'package:hero_dash/settings/player_settings.dart';
import 'package:hero_dash/utils/math_utils.dart';

class Player extends RectangleComponent
    with HasGameReference<GameApp>, CollisionCallbacks {
  late final double _jumpHeight;
  final double _gravity = PlayerSettings.gravity;
  late double _initialJumSpeed;
  final int _maxHealth = 3;
  late int _health;
  bool _isDead = false;

  HealthObserver? _healthObserver;

  bool _isOnGround = true;
  double _verticalVelocity = 0;

  int get maxHealth => _maxHealth;

  int get currentHealth => _health;

  Player({required super.position})
    : super(
        size: Vector2(50, 100),
        anchor: Anchor.bottomCenter,
        paint: Paint()..color = Color.fromRGBO(255, 1, 1, 1),
      ) {
    _health = _maxHealth;
  }

  @override
  FutureOr<void> onLoad() {
    _getJumpValues();

    add(RectangleHitbox());

    return super.onLoad();
  }

  void _getJumpValues() {
    _jumpHeight = game.size.y / 2;
    _initialJumSpeed =
        -MathUtils.getInitialJumpSpeed(g: _gravity, h: _jumpHeight);
  }

  @override
  void update(double dt) {
    super.update(dt);

    _jumpUpdate(dt);
  }

  void jump() {
    if (_isOnGround) {
      _isOnGround = false;
      _verticalVelocity = _initialJumSpeed;
    }
  }

  /// Обработка движения игрока во время прыжка
  void _jumpUpdate(double dt) {
    if (!_isOnGround) {
      _verticalVelocity += _gravity * dt;

      position.y += _verticalVelocity * dt;

      if (position.y >= game.size.y - 10 && !_isOnGround) {
        position.y = game.size.y - 10;
        _isOnGround = true;
        _verticalVelocity = 0;
      }
    }
  }

  void takeDamage(int value) {
    _health -= value;
    _healthObserver?.onHealthChanged(_health);
    if (_health <= 0) {
      death();
    }
  }

  void death() {
    _isDead = true;
    game.playerDied();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Obstacle) {
      takeDamage(1);
    }
  }

  void subscribeHealthObserver(HealthObserver observer) {
    _healthObserver = observer;
    _healthObserver?.onHealthChanged(currentHealth);
    _healthObserver?.onMaxHealthChanged(maxHealth);
  }

  void removeHealthObserver(HealthObserver observer) {
    _healthObserver = null;
  }
}
