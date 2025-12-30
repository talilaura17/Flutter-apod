import 'package:flutter/cupertino.dart';

class ViewedDateState extends ChangeNotifier {
  final Set<String> _viewedDates = {};

  bool isViewed(String date) => _viewedDates.contains(date);

  void markViewed(String date) {
    if (_viewedDates.add(date)) {
      notifyListeners();
    }
  }

  Set<String> get all => _viewedDates;

}