import 'package:flutter/material.dart';

import '../models/ui.dart';

class SimpleProvider with ChangeNotifier {
  int page = 1;
  String title = Ui.name;
  int indexSelected = -1;

  // Uz_ru uz_ru = Uz_ru.UZ;
  List<int> listIndex = [];

//=================================
  int get getpage => page;

  String get gettitle => title;

  int get getindexSelected => indexSelected;

  //=================================

  void changepage(int newPage) {
    this.page = newPage;
    notifyListeners();
  }

  void changetitle(String newtitle) {
    this.title = newtitle;
    notifyListeners();
  }

  void changeindexSelected(int newindexSelected) {
    this.indexSelected = newindexSelected;
    notifyListeners();
  }
}
