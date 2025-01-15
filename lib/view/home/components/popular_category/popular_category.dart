import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_grocery/controller/theme_controller.dart';
import 'package:my_grocery/model/category.dart';

import 'popular_category_card.dart';

class PopularCategory extends StatelessWidget {
  final List<Category> categories;
  const PopularCategory({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    return Container(
      color: themeController.isDarkMode
          ? themeController.color_darkMode
          : themeController.color_lightMode,
      height: 140,
      padding: const EdgeInsets.only(right: 10),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: categories.length,
          itemBuilder: (context, index) =>
              PopularCategoryCard(category: categories[index])),
    );
  }
}
