import 'package:flutter/material.dart';

//ChengeNotifier funciona parecido com o setstate porém não é para tela, sim para o código
class AppController extends ChangeNotifier {
  static AppController instance = AppController();

  bool isDarkTheme = false;
  changeTheme() {
    isDarkTheme = !isDarkTheme;
    notifyListeners();
  }
}
