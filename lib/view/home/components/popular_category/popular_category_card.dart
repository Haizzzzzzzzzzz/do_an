import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_grocery/const.dart';
import 'package:my_grocery/model/category.dart';
import 'package:shimmer/shimmer.dart';
import 'package:my_grocery/controller/dashboard_controller.dart'; // Import Controller
import 'package:my_grocery/controller/product_controller.dart'; // Import Controller
import 'package:get/get.dart'; // Import GetX

class PopularCategoryCard extends StatelessWidget {
  final Category category;
  const PopularCategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // final DashboardController dashboardController = Get.find();
    final DashboardController dashboardController =
        Get.put(DashboardController());

    // final ProductController productController = Get.find();
    final ProductController productController = Get.put(ProductController());

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
      child: InkWell(
        onTap: () {
          dashboardController.updateIndex(1); // Chuyển tab index
          productController.searchTextEditController.text =
              'cat: ${category.name}'; // Cập nhật bộ lọc tìm kiếm
          productController.searchVal.value =
              'cat: ${category.name}'; // Cập nhật giá trị tìm kiếm
          productController.getProductByCategory(
              id: category.id); // Lấy sản phẩm theo category
        },
        child: CachedNetworkImage(
          //imageUrl: baseUrl + category.image,//Hồi trước để như này để chạy local
          imageUrl: category.image,
          imageBuilder: (context, imageProvider) => Material(
            elevation: 8,
            shadowColor: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 270,
              height: 140,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover)),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  category.name,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          placeholder: (context, url) => Material(
            elevation: 8,
            shadowColor: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.white,
              child: Container(
                width: 270,
                height: 140,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Material(
            elevation: 8,
            shadowColor: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 270,
              height: 140,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10)),
              child: const Center(
                child: Icon(
                  Icons.error_outline,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
