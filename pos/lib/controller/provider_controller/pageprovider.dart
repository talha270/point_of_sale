import 'package:flutter/material.dart';

class Pageprovider with ChangeNotifier{
  final PageController controller =PageController();
  int _currentindex=0;
  int get currentindex=>_currentindex;
  onchange(int index){
    _currentindex=index;
    controller.jumpToPage(_currentindex);
    notifyListeners();
  }

}
