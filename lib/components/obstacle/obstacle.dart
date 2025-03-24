import 'package:flame/components.dart';

abstract class Obstacle {
  double speed;
  int health;
  final int maxHealth;
  late Vector2 velocity;

  Obstacle({
    required this.health,
    required this.maxHealth,
    required this.speed,
  });

  void move(double dt);

  void takeDamage(int value);

  void removeFromGame();

  void updateSpeed(double newSpeed);
}
