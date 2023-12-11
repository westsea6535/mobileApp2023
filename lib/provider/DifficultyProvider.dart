import 'package:flutter/material.dart';

class DifficultyLevel with ChangeNotifier {
  String _level = '';

  String get level => _level;

  setLevel(String newLevel) {
    _level = newLevel;
    notifyListeners();
  }
}
