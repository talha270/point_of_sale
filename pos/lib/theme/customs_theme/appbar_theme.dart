import 'package:flutter/material.dart';
class Appbartheme{
  Appbartheme._();
  static const lightappbartheme= AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: Colors.black,size: 24),
    actionsIconTheme: IconThemeData(color: Colors.black,size: 24),
    titleTextStyle: TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: Colors.black),
  );
  static const darkappbartheme=AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: Colors.black,size: 24),
    actionsIconTheme: IconThemeData(color: Colors.white,size: 24),
    titleTextStyle: TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: Colors.white),
  );
}