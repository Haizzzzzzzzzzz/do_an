import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:my_grocery/const.dart';
import 'package:my_grocery/controller/theme_controller.dart';
import 'package:shimmer/shimmer.dart';

import '../../../model/product.dart';
import '../../product_details/product_details_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return InkWell(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(product: product)));
      },
      child: Material(
        elevation: 8,
        shadowColor: Colors.grey.shade300,
        color: themeController.isDarkMode
            ? themeController.color_darkMode
            : themeController.color_lightMode,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 5,
                child: Center(
                  child: CachedNetworkImage(
                    //imageUrl: baseUrl + product.images.first,//Hồi trước để như này để chạy local
                    imageUrl: product.images.first,
                    placeholder: (context, url) => Shimmer.fromColors(
                      highlightColor: Colors.white,
                      baseColor: Colors.grey.shade300,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.grey.shade300,
                      ),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${NumberFormat('#,##0', 'vi').format(product.tags.first.price)} ₫',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
