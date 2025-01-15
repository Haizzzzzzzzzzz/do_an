import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_grocery/const.dart';
import 'package:my_grocery/view/product_details/product_details_screen.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../model/product.dart';
import '../../../../controller/theme_controller.dart';

class PopularProductCard extends StatelessWidget {
  final Product product;
  const PopularProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final themeController =
        Get.find<ThemeController>(); // Lấy trạng thái Dark Mode

    return InkWell(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
        child: Material(
          elevation: 8,
          color: themeController.isDarkMode
              ? Colors.grey.shade900
              : Colors.grey.shade300,
          shadowColor: themeController.isDarkMode
              ? Colors.black.withOpacity(0.4)
              : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            margin: const EdgeInsets.all(10),
            width: 120,
            decoration: BoxDecoration(
              color: themeController.isDarkMode
                  ? Colors.grey.shade900
                  : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 0.9,
                  child: CachedNetworkImage(
                    //imageUrl: baseUrl + product.images.first,//Hồi trước để như này để chạy local
                    imageUrl: product.images.first,
                    placeholder: (context, url) => Shimmer.fromColors(
                      highlightColor: themeController.isDarkMode
                          ? Colors.grey.shade700
                          : Colors.white,
                      baseColor: themeController.isDarkMode
                          ? Colors.grey.shade800
                          : Colors.grey.shade300,
                      child: Container(
                        color: themeController.isDarkMode
                            ? Colors.grey.shade800
                            : Colors.grey,
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error_outline,
                      color: themeController.isDarkMode
                          ? Colors.grey.shade500
                          : Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10),
                  child: Text(
                    product.name,
                    style: TextStyle(
                      color: themeController.isDarkMode
                          ? Colors.white
                          : Colors.black,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
