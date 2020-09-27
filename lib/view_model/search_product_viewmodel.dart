import 'package:flutter/material.dart';

class SearchProductViewModel extends ChangeNotifier {
  String _searchString = '';

  String get searchString => _searchString;

  void setSearchString(String newtext) {
    _searchString = newtext;
    notifyListeners();
  }
}
