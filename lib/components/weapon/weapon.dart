import 'package:flame/components.dart';

abstract class Weapon {
  final int damage;
  final double attackSpeed;

  Weapon({required this.damage, required this.attackSpeed});

  void attack();
}