import 'package:flutter/material.dart';

class ScoreProvider extends ChangeNotifier {
  // Define your map here
  Map<String, dynamic> _myScore = {'total': 1, 'correct': 1};

  // Getter to access the map data
  Map<String, dynamic> get myScore => _myScore;

  // Method to update the map data
  void updateMap(Map<String, dynamic> newMap) {
    _myScore = newMap;
    notifyListeners(); // Notify listeners that the data has changed
  }
}
