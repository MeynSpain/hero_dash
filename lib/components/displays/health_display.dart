import 'dart:async';

import 'package:flame/components.dart';
import 'package:hero_dash/components/player.dart';
import 'package:hero_dash/game_app.dart';
import 'package:hero_dash/observers/health_observer.dart';

class HealthDisplay extends TextComponent implements HealthObserver {
  int _currentHealth = 0;
  int _maxHealth = 0;
  String _text = '';

  HealthDisplay({required super.position}) {
    _text = '$_currentHealth / $_maxHealth';
    text = _text;
  }

  @override
  void onHealthChanged(int newHealth) {
    _currentHealth = newHealth;
    _updateText(_currentHealth, _maxHealth);
  }

  void _updateText(int currentHealth, int maxHealth) {
    _text = '$_currentHealth / $_maxHealth';
    text = _text;
  }

  @override
  void onMaxHealthChanged(int maxHealth) {
    _maxHealth = maxHealth;
    _updateText(_currentHealth, _maxHealth);
  }
}
