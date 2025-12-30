import 'package:flutter/cupertino.dart';

import 'apod_data.dart';

class FavoriteState extends ChangeNotifier{
  List<ApodData> favoriteList = [];

  bool contains(String date) => favoriteList.any((e) => e.date == date);

  ApodData? item(String date) {
    try {
      return favoriteList.firstWhere((e) => e.date == date);
    } catch (_) {
      return null;
    }
  }

  void addToList(ApodData apodData){
    favoriteList.add(apodData);
    notifyListeners(); // 通知使用到這個data model的UI重新渲染
  }

  void removeFromList(ApodData apodData){
    favoriteList.removeWhere((e) => e.date == apodData.date);
    notifyListeners();
  }
}