import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_grocery/controller/cart_controller.dart';
import 'package:my_grocery/controller/controllers.dart';
import 'package:my_grocery/controller/theme_controller.dart';
import '../view/Cart/cart_screen.dart';

class MainHeader extends StatelessWidget {
  const MainHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final themeController = Get.find<ThemeController>();

    return Container(
      decoration: BoxDecoration(
        color: themeController.isDarkMode
            ? themeController.color_darkMode
            : Colors.grey[100],
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: themeController.isDarkMode
                ? themeController.color_darkMode
                : Colors.grey[400]!,
            blurRadius: 10,
          )
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: themeController.isDarkMode
                    ? Colors.grey.shade800
                    : Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(24)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: themeController.isDarkMode
                        ? Colors.black.withOpacity(0.6)
                        : Colors.grey.withOpacity(0.6),
                    offset: const Offset(0, 0),
                    blurRadius: 8,
                  )
                ],
              ),
              child: Obx(
                () => TextField(
                  autofocus: false,
                  controller: productController.searchTextEditController,
                  onSubmitted: (val) {
                    productController.getProductByName(keyword: val);
                    dashboardController.updateIndex(1);
                  },
                  onChanged: (val) {
                    productController.searchVal.value = val;
                  },
                  decoration: InputDecoration(
                    suffixIcon: productController.searchVal.value.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: themeController.isDarkMode
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              productController.searchTextEditController
                                  .clear();
                              productController.searchVal.value = '';
                              productController.getProducts();
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 16),
                    fillColor: themeController.isDarkMode
                        ? Colors.grey.shade700
                        : Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Tìm kiếm sản phẩm...",
                    hintStyle: TextStyle(
                        color: themeController.isDarkMode
                            ? Colors.grey.shade300
                            : Colors.grey.shade600,
                        fontSize: 13),
                    prefixIcon: Icon(
                      Icons.search,
                      color: themeController.isDarkMode
                          ? Colors.white
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: themeController.isDarkMode
                  ? Colors.grey.shade800
                  : Colors.white,
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: themeController.isDarkMode
                      ? Colors.black.withOpacity(0.6)
                      : Colors.grey.withOpacity(0.6),
                  blurRadius: 8,
                )
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.filter_alt_outlined,
              color: themeController.isDarkMode ? Colors.white : Colors.grey,
            ),
          ),
          const SizedBox(width: 10),
          badges.Badge(
            badgeContent: const Text(
              " ",
              style: TextStyle(color: Colors.white),
            ),
            badgeStyle: badges.BadgeStyle(
              badgeColor: Theme.of(context).primaryColor,
            ),
            child: GestureDetector(
              onTap: () async {
                await cartController.loadCartItems();
                Get.put(CartController());
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen()),
                );
              },
              child: Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: themeController.isDarkMode
                      ? Colors.grey.shade800
                      : Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: themeController.isDarkMode
                          ? Colors.black.withOpacity(0.6)
                          : Colors.grey.withOpacity(0.6),
                      blurRadius: 8,
                    )
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color:
                      themeController.isDarkMode ? Colors.white : Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }
}
