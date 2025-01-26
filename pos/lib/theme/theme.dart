import 'package:flutter/material.dart';
import 'customs_theme/appbar_theme.dart';
import 'customs_theme/bottem_sheet_theme.dart';
import 'customs_theme/checkbox_theme.dart';
import 'customs_theme/chip_theme.dart';
import 'customs_theme/elevated_button_theme.dart';
import 'customs_theme/outlined_button_theme.dart';
import 'customs_theme/text_field_theme.dart';
import 'customs_theme/text_theme.dart';
class Apptheme{

  Apptheme._();
  static ThemeData lighttheme= ThemeData(
    useMaterial3: true,
    shadowColor: Colors.black,
    focusColor: Colors.black,
    brightness: Brightness.light,
    primaryColor: Colors.black12,
    scaffoldBackgroundColor: Colors.white,
    textTheme: Etexttheme.lighttexttheme,
    chipTheme: Echiptheme.lightchiptheme,
    appBarTheme: Appbartheme.lightappbartheme,
    checkboxTheme: Checkboxtheme.lightcheckboxtheme,
    bottomSheetTheme: Bottemsheettheme.lightbottomsheetthemedata,
    elevatedButtonTheme: Eelevatedbuttontheme.lightelevatedbuttontheme,
    outlinedButtonTheme: Eoutlinebuttontheme.lightoutlinebuttontheme,
    inputDecorationTheme: Etextfieldtheme.lighttextfieldtheme

  );
  static ThemeData darktheme= ThemeData(
    shadowColor: Colors.white24,
    useMaterial3: true,
    focusColor: Colors.white,
    brightness: Brightness.dark,
    primaryColor: Colors.white10,
    scaffoldBackgroundColor: Colors.black,
    textTheme: Etexttheme.darktexttheme,
      chipTheme: Echiptheme.darkchiptheme,
      appBarTheme: Appbartheme.darkappbartheme,
      checkboxTheme: Checkboxtheme.darkcheckboxtheme,
      bottomSheetTheme: Bottemsheettheme.darkbottomsheetthemedata,
      elevatedButtonTheme: Eelevatedbuttontheme.darkelevatedbuttontheme,
      outlinedButtonTheme: Eoutlinebuttontheme.darkoutlinebuttontheme,
      inputDecorationTheme: Etextfieldtheme.darktextfieldtheme
  );
}