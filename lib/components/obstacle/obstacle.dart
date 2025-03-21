abstract class Obstacle {
  final double speed;
  int health;
  final int maxHealth;

  Obstacle({
    required this.health,
    required this.maxHealth,
    required this.speed,
  });

  void move(double dt);

  void takeDamage(int value);
}
