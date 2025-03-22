import 'package:flame/components.dart';
import 'package:hero_dash/components/attack_component.dart';
import 'package:hero_dash/components/weapon/weapon.dart';

class MeleeWeapon extends Weapon {
  // @override
  // final int damage;
  // @override
  // final double attackSpeed;

  final double range;
  final double widthAttack;
  final double knockBackRange;

  double coolDown = 0;

  MeleeWeapon({
    required this.knockBackRange,
    required this.range,
    required this.widthAttack,
    required super.damage,
    required super.attackSpeed,
  });

  @override
  void attack() {
    print('Атака из оружия');
    // if (coolDown <= 0) {
    //   // Создается невидимый прямоугольник, который просчитывает коллизии и наносит урон
    //   // После чего удаляется
    //   final attackComponent = AttackComponent(
    //     damage: damage,
    //     knockBackRange: knockBackRange,
    //     size: Vector2(range, widthAttack),
    //     position: attackPosition,
    //   );
    //
    //   Future.delayed(Duration(milliseconds: 100), () {
    //     attackComponent.removeFromParent();
    //     print('AttackComponent должен был удалиться');
    //   });
    // }
  }

  void updateCoolDown(double dt) {
    if (coolDown <= 0) return;

    coolDown -= dt;
  }
}
