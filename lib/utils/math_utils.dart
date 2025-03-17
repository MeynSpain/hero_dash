import 'dart:math';

class MathUtils {
  MathUtils._();

  /// Вычисляет начальную скорость прыжка по формуле
  /// [sqrt(2 * g * h)], где
  /// g - гравитаци
  /// h - высота
  static double getInitialJumpSpeed({required double g, required double h}) {
    return sqrt(2 * g * h);
  }
}
