import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:hero_dash/game_app.dart';
import 'package:hero_dash/settings/player_settings.dart';
import 'package:hero_dash/utils/math_utils.dart';

class Player extends RectangleComponent with HasGameReference<GameApp> {
  late final double _jumpHeight;
  final double _gravity = PlayerSettings.gravity;
  late double _initialJumSpeed;

  bool _isOnGround = true;
  double _verticalVelocity = 0;

  Player({required super.position})
    : super(
        size: Vector2(50, 100),
        anchor: Anchor.bottomCenter,
        paint: Paint()..color = Color.fromRGBO(255, 1, 1, 1),
      );

  @override
  FutureOr<void> onLoad() {
    _getJumpValues();
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
      log('Jump tap');
    }
  }

  /// Обработка движения игрока во время прыжка
  void _jumpUpdate(double dt) {
    if (!_isOnGround) {
      _verticalVelocity += _gravity * dt;

      position.y += _verticalVelocity * dt;

      log('$_verticalVelocity');

      if (position.y >= game.size.y - 10 && !_isOnGround) {
        position.y = game.size.y - 10;
        _isOnGround = true;
        _verticalVelocity = 0;
      }
    }
  }
}
