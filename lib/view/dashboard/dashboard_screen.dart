import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:get/get.dart';
import 'package:my_grocery/controller/dashboard_controller.dart';
import 'package:my_grocery/controller/theme_controller.dart';
import 'package:my_grocery/view/category/category_screen.dart';
import 'package:my_grocery/view/AI/chatbot_screen.dart';
import 'package:my_grocery/view/home/home_screen.dart';
import 'package:my_grocery/view/product/product_screen.dart';

import '../account/account_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    return GetBuilder<DashboardController>(
      builder: (controller) => Scaffold(
        backgroundColor: themeController.isDarkMode
            ? themeController.color_darkMode
            : themeController.color_lightMode,
        body: SafeArea(
          child: IndexedStack(
            index: controller.tabIndex,
            children: const [
              HomeScreen(),
              ProductScreen(),
              CategoryScreen(),
              ChatBotScreen(
                selectedTitles: [],
              ),
              AccountScreen()
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: themeController.isDarkMode
                ? Colors.grey.shade800 // Nền tối khi Dark Mode
                : Colors.white, // Nền sáng khi Light Mode
            border: Border(
              top: BorderSide(
                color: themeController.isDarkMode
                    ? Colors.grey.shade600 // Viền tối
                    : Theme.of(context).colorScheme.secondary, // Viền sáng
                width: 0.7,
              ),
            ),
          ),
          child: SnakeNavigationBar.color(
            backgroundColor: themeController.isDarkMode
                ? themeController.color_darkMode
                : themeController.color_lightMode,
            behaviour: SnakeBarBehaviour.floating,
            snakeShape: SnakeShape.circle,
            padding: const EdgeInsets.symmetric(vertical: 5),
            unselectedLabelStyle: const TextStyle(fontSize: 11),
            snakeViewColor: Theme.of(context).primaryColor,
            unselectedItemColor: themeController.isDarkMode
                ? Colors.grey.shade400 // Màu chữ khi Dark Mode
                : Theme.of(context)
                    .colorScheme
                    .secondary, // Màu chữ khi Light Mode
            showUnselectedLabels: true,
            currentIndex: controller.tabIndex,
            onTap: (val) {
              controller.updateIndex(val);
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: 'Trang Chủ'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_business_sharp), label: 'Sản Phẩm'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.menu), label: 'Danh Mục'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.group_work_outlined), label: 'AI'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle), label: 'Tài Khoản'),
            ],
          ),
        ),
      ),
    );
  }
}
