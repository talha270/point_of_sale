import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Salesprovider extends ChangeNotifier {
  String _selecteddate = 'all';
  String get selecteddate => _selecteddate;

  void changedate(String newCategory) {
    _selecteddate = newCategory;
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getitems(List<Map<String, dynamic>> allItems) async {
    if (_selecteddate == 'all') {
      return allItems;
    }else if(_selecteddate == 'today'){
      return allItems.where((sales)=>sales["date"]== DateFormat('yyyy-MM-dd').format(DateTime.now())).toList();
    } else {
      return allItems.where((item) => item["date"] == _selecteddate).toList();
    }
  }
}
