import 'package:flutter/material.dart';


class Categoriesitem extends ChangeNotifier {
  String _selectedCategory = 'all';
  String _search="";
  String get selectedCategory => _selectedCategory;

  void changename(String newCategory) {
    _selectedCategory = newCategory;
    notifyListeners();
  }
  void changesearch({required String search,required String newCategory}) {
    _selectedCategory = newCategory;
    _search = search;
    notifyListeners();
  }
  Future<List<Map<String, dynamic>>> getitems(List<Map<String, dynamic>> allItems) async {
    if (_selectedCategory == 'all') {
      return allItems;
    } else if(_selectedCategory=="search"){
      return allItems.where((items)=>items["name"]==_search).toList();
    }else {
      return allItems.where((item) => item['categories'] == _selectedCategory).toList();
    }
  }

}