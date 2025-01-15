import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_grocery/controller/theme_controller.dart';
import 'package:my_grocery/view/home/components/popular_product/popular_product_card.dart';

import '../../../../model/product.dart';

class PopularProduct extends StatelessWidget {
  final List<Product> popularProducts;
  const PopularProduct({super.key, required this.popularProducts});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Container(
      color: themeController.isDarkMode
          ? themeController.color_darkMode
          : themeController.color_lightMode,
      height: 220,
      padding: const EdgeInsets.only(right: 10),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: popularProducts.length,
          itemBuilder: (context, index) =>
              PopularProductCard(product: popularProducts[index])),
    );
  }
}
