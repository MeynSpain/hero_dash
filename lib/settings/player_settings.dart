import 'package:flame/components.dart';

class PlayerSettings {
  PlayerSettings._();

  /// Размеры игрока
  static Vector2 playerSize = Vector2(50, 100);

  /// Высота прыжка
  static const double jumpHeight = 200;

  /// Сила гравитации
  static const double gravity = 800;

  /// Начальная скорость прыжка
  static const double initialJumpSpeed = 400;

}