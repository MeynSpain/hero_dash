import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:hero_dash/components/attack_component.dart';
import 'package:hero_dash/components/obstacle/enemy_obstacle/enemy_obstacle.dart';
import 'package:hero_dash/components/obstacle/obstacle.dart';
import 'package:hero_dash/components/weapon/melee_weapon/melee_weapon.dart';
import 'package:hero_dash/components/weapon/weapon.dart';
import 'package:hero_dash/game_app.dart';
import 'package:hero_dash/observers/health_observer.dart';
import 'package:hero_dash/settings/player_settings.dart';
import 'package:hero_dash/utils/math_utils.dart';

class Player extends RectangleComponent
    with HasGameReference<GameApp>, CollisionCallbacks {
  // Система прыжков
  late final double _jumpHeight;
  final double _gravity = PlayerSettings.gravity;
  late double _initialJumSpeed;
  bool _isOnGround = true;
  double _verticalVelocity = 0;

  // Для двойного прыжка
  int _jumpCount = 0; // Сколько прыжков совершил игрок
  int _maxJumpCount = 3; // Кол-во прыжков + планирование.

  // Планирование (глайдинг)
  bool _isGliding = false;

  // Система здоровья
  final int _maxHealth = 3;
  late int _health;
  bool _isDead = false;

  // Дэш
  final double dashMultiplier = 4.0;
  final int dashDuration = 500;
  bool canDash = true;

  HealthObserver? _healthObserver;

  final MeleeWeapon weapon = MeleeWeapon(
    knockBackRange: 400,
    range: 100,
    widthAttack: 50,
    damage: 1,
    attackSpeed: 0.1,
  );

  late AttackComponent attackComponent;

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

    attackComponent = AttackComponent(
      damage: weapon.damage,
      knockBackRange: weapon.knockBackRange,
      size: Vector2(weapon.range, weapon.widthAttack),
      position: Vector2(size.x, size.y / 2),
    );

    add(attackComponent);

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
    weapon.updateCoolDown(dt);
  }

  void jump() {
    if (_isOnGround || _jumpCount < _maxJumpCount) {
      _isOnGround = false;
      _jumpCount++;
      if (_jumpCount < _maxJumpCount) {
        _verticalVelocity = _initialJumSpeed;
      }
      print('Jumps: $_jumpCount');
    }
  }

  /// Обработка движения игрока во время прыжка
  void _jumpUpdate(double dt) {
    if (!_isOnGround) {
      _verticalVelocity += _gravity * dt;

      if (_isGliding) {
        _verticalVelocity = _verticalVelocity.clamp(
          -_gravity * 0.5,
          _gravity * 0.1,
        );
      }

      position.y += _verticalVelocity * dt;

      if (position.y >= game.size.y - 10 && !_isOnGround) {
        position.y = game.size.y - 10;
        _verticalVelocity = 0;
        _jumpCount = 0;
        _isOnGround = true;
        stopGliding();
      }
    }
  }

  void startGliding() {
    if (!_isOnGround && _jumpCount == _maxJumpCount) {
      _isGliding = true;
      size = Vector2(size.y, size.x);
    }
  }

  void stopGliding() {
    if (_isGliding) {
      size = Vector2(size.y, size.x);
    }
    _isGliding = false;
  }

  void dash() {
    if (!canDash) return;

    canDash = false;

    print('Dash Activate');

    game.activateDash(dashMultiplier, Duration(milliseconds: dashDuration));

    Future.delayed(Duration(milliseconds: dashDuration), () {
      canDash = true;
    });
  }

  void takeDamage(int value) {
    _health = max(_health - value, 0);
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

  void attack() {
    if (weapon.coolDown <= 0) {
      attackComponent.activate();
      weapon.attack();
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
