import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_grocery/service/theme_service.dart';

class ThemeController extends GetxController {
  bool get isDarkMode => ThemeService().currentThemeMode == ThemeMode.dark;
  var color_darkMode = Colors.black;
  var color_lightMode = Colors.white;
  // Hàm chuyển đổi chế độ
  void toggleTheme() => ThemeService().toggleTheme();
}
