import 'package:flutter/material.dart';

class ColorTheme extends ChangeNotifier {
  // Define your map here


  int _selectedTheme = 0;

  int get selectedTheme => _selectedTheme;
  void update(int newInt) {
    _selectedTheme = newInt;
    notifyListeners();
  }

  void increment() {
    _selectedTheme++;
    notifyListeners();
  }

  void decrement() {
    _selectedTheme--;
    notifyListeners();
  }
}
