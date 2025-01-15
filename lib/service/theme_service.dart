import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService extends GetxService {
  final _box = GetStorage(); // Lưu trạng thái theme
  final _key = 'isDarkMode'; // Khóa để lưu trạng thái theme

  RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _loadThemeFromBox(); // Khởi tạo trạng thái từ storage
  }

  bool _loadThemeFromBox() {
    return _box.read(_key) ?? false; // Mặc định là Light Mode
  }

  ThemeMode get currentThemeMode =>
      _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  void _saveThemeToBox(bool isDarkMode) {
    _box.write(_key, isDarkMode);
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _saveThemeToBox(isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
