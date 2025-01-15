import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_grocery/controller/theme_controller.dart';
import 'package:my_grocery/service/theme_service.dart';

class SettingScreen extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());
  final ThemeService themeService = Get.find<ThemeService>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: themeController.isDarkMode
          ? themeController.color_darkMode
          : themeController.color_lightMode,
      appBar: AppBar(
        title: const Text("Cài Đặt"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Text(
                "Cài Đặt Hiển Thị",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color:
                      themeController.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // Dark Mode Switch
              Card(
                color: themeController.isDarkMode
                    ? Colors.grey.shade800
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 5,
                child: ListTile(
                  leading: Icon(
                    Icons.dark_mode,
                    color: themeController.isDarkMode
                        ? Colors.white
                        : theme.primaryColor,
                  ),
                  title: Text(
                    "Dark Mode",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: themeController.isDarkMode
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  trailing: Obx(
                    () => Switch(
                      value: themeService.isDarkMode.value,
                      activeColor: theme.primaryColor,
                      inactiveThumbColor: Colors.grey,
                      onChanged: (bool value) {
                        themeService.toggleTheme();
                        _restartApp(); // Load lại ứng dụng
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Additional Setting Options (Placeholder)
              Card(
                color: themeController.isDarkMode
                    ? Colors.grey.shade800
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 5,
                child: ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: themeController.isDarkMode
                        ? Colors.white
                        : theme.primaryColor,
                  ),
                  title: Text(
                    "Thông Tin Ứng Dụng",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: themeController.isDarkMode
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    // Điều hướng đến thông tin ứng dụng
                    Get.toNamed('/about');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Hàm khởi động lại toàn bộ ứng dụng
  void _restartApp() {
    Get.offAllNamed('/'); // Điều hướng về trang chính của ứng dụng
  }
}
