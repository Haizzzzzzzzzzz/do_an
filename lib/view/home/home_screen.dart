import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:my_grocery/component/main_header.dart';
import 'package:my_grocery/controller/controllers.dart';
import 'package:my_grocery/controller/theme_controller.dart';
import 'package:my_grocery/view/AI/ai_image_screen.dart';
import 'package:my_grocery/view/home/components/build_Divider.dart';
import 'package:my_grocery/view/home/components/popular_category/popular_category.dart';
import 'package:my_grocery/view/home/components/popular_product/popular_product.dart';
import 'package:my_grocery/view/home/components/popular_product/popular_product_loading.dart';
import 'package:my_grocery/view/home/components/section_title.dart';
// Import ProductGrid
import 'package:my_grocery/view/product/components/product_grid_home.dart';

import 'components/carousel_slider/carousel_slider_view.dart';
import 'components/popular_category/popular_category_loading.dart';
import 'components/carousel_slider/carousel_loading.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeController = Get.put(ThemeController());

    return Scaffold(
      backgroundColor: themeController.isDarkMode
          ? themeController.color_darkMode
          : themeController.color_lightMode,
      body: SafeArea(
          child: Column(children: [
        const MainHeader(),
        Expanded(
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(children: [
                  Obx(() {
                    if (homeController.bannerList.isNotEmpty) {
                      return CarouselSliderView(
                        bannerList: homeController.bannerList,
                      );
                    } else {
                      return const CarouselLoading();
                    }
                  }),
                  const SectionTitle(title: "Nhãn Hàng Phổ Biến"),
                  Obx(() {
                    if (homeController.popularCategoryList.isNotEmpty) {
                      return PopularCategory(
                          categories: homeController.popularCategoryList);
                    } else {
                      return const PopularCategoryLoading();
                    }
                  }),
                  const SectionTitle(title: "Sản Phẩm Phổ Biến"),
                  Obx(() {
                    if (homeController.popularProductList.isNotEmpty) {
                      return PopularProduct(
                          popularProducts: homeController.popularProductList);
                    } else {
                      return const PopularProductLoading();
                    }
                  }),
                  Column(
                    children: [
                      const buildDivider(),
                      Center(
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 16.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: themeController.isDarkMode
                                ? Colors.grey.shade800 // Nền tối khi Dark Mode
                                : Colors.white, // Nền sáng khi Light Mode
                            border: Border.all(
                              color: theme.primaryColor,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: themeController.isDarkMode
                                    ? Colors.black.withOpacity(0.4) // Bóng tối
                                    : Colors.grey.withOpacity(0.3), // Bóng sáng
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            'TẠO ỐP ĐIỆN THOẠI PHONG CÁCH',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: themeController.isDarkMode
                                  ? Colors.white // Chữ trắng khi Dark Mode
                                  : Colors.black, // Chữ đen khi Light Mode
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeController.isDarkMode
                                    ? Colors
                                        .grey.shade900 // Nền tối khi Dark Mode
                                    : Colors.white, // Nền sáng khi Light Mode
                                foregroundColor: themeController.isDarkMode
                                    ? Colors.white // Chữ trắng khi Dark Mode
                                    : theme
                                        .primaryColor, // Chữ màu chính khi Light Mode
                                textStyle: const TextStyle(fontSize: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                EasyLoading.show(
                                  status: 'Loading...',
                                  dismissOnTap: false,
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AiImageScreen(),
                                  ),
                                );
                                EasyLoading.dismiss();
                              },
                              child: Image.asset(
                                'assets/create_image.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const buildDivider(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                        child: Text(
                          "GỢI Ý SẢN PHẨM",
                          style: TextStyle(
                            fontSize: 18,
                            color: themeController.isDarkMode
                                ? Colors.white // Chữ trắng khi Dark Mode
                                : Colors.black, // Chữ đen khi Light Mode
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Obx(() {
                        if (productController.productList.isNotEmpty) {
                          return ProductGridHome(
                            products:
                                productController.productList.take(15).toList(),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                    ],
                  ),
                ])))
      ])),
    );
  }
}
