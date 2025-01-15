import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_grocery/controller/theme_controller.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>(); // Lấy themeController

    return Container(
      color: themeController.isDarkMode
          ? themeController.color_darkMode
          : themeController.color_lightMode,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: themeController.isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "Xem thêm",
            style: TextStyle(
              color: themeController.isDarkMode
                  ? Colors.grey.shade400
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
