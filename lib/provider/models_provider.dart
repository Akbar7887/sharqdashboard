import 'package:flutter/material.dart';

import '../models/ModelSet.dart';

class ModelsProvider with ChangeNotifier {
  ModelSet? modelSet = null;

  ModelSet get getmodel => modelSet!;

  void changemodel(ModelSet newmodelSet) {
    this.modelSet = newmodelSet;
    notifyListeners();
  }
}
