import 'package:flutter/material.dart';

class SentencesList extends ChangeNotifier {
  List<String> _items = [];

  List<String> get items => _items;

  void setList(List<String> initialData) {
    _items = initialData;
    notifyListeners(); // Notify listeners to update the UI
  }

  void addItem(String item) {
    _items.add(item);
    notifyListeners(); // Notify listeners when the list is updated
  }

  void removeItem(String item) {
    _items.remove(item);
    notifyListeners(); // Notify listeners when the list is updated
  }
}
