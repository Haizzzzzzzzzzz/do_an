import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_grocery/controller/controllers.dart';
import 'package:my_grocery/controller/theme_controller.dart';
import '../../model/cart_item.dart';
import '../../model/product.dart';
import '../../controller/cart_controller.dart';
import 'components/product_carousel_slider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final CartController cartController = Get.find<CartController>();
  final ThemeController themeController = Get.put(ThemeController());
  NumberFormat formatter = NumberFormat('00');
  int _qty = 1;
  int _selectedTagIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode
          ? themeController.color_darkMode
          : themeController.color_lightMode,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductCarouselSlider(images: widget.product.images),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  widget.product.name,
                  style: TextStyle(
                    fontSize: 24,
                    color: themeController.isDarkMode
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '${NumberFormat('#,##0', 'vi').format(widget.product.tags[_selectedTagIndex].price)} ₫',
                  style: TextStyle(
                    fontSize: 18,
                    color: themeController.isDarkMode
                        ? Colors.white70
                        : Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Divider(
                color: themeController.isDarkMode
                    ? Colors.grey.shade700
                    : Colors.grey.shade300,
                thickness: 1,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Phân loại:",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(widget.product.tags.length, (index) {
                    final tag = widget.product.tags[index];
                    final isSelected = _selectedTagIndex == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTagIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : themeController.isDarkMode
                                  ? Colors.grey.shade800
                                  : Colors.white,
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : themeController.isDarkMode
                                    ? Colors.grey.shade600
                                    : Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tag.title,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : themeController.isDarkMode
                                    ? Colors.grey.shade300
                                    : Colors.grey.shade800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 10),
              Divider(
                color: themeController.isDarkMode
                    ? Colors.grey.shade700
                    : Colors.grey.shade300,
                thickness: 1,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Số lượng:",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: themeController.isDarkMode
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: themeController.isDarkMode
                            ? Colors.grey.shade800
                            : Colors.white,
                        border: Border.all(
                          color: themeController.isDarkMode
                              ? Colors.grey.shade600
                              : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (_qty > 1) {
                                setState(() {
                                  _qty--;
                                });
                              }
                            },
                            child: Icon(
                              Icons.remove,
                              size: 32,
                              color: themeController.isDarkMode
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade800,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              formatter.format(_qty),
                              style: TextStyle(
                                fontSize: 18,
                                color: themeController.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _qty++;
                              });
                            },
                            child: Icon(
                              Icons.add,
                              size: 32,
                              color: themeController.isDarkMode
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Mô tả sản phẩm:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: themeController.isDarkMode
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  widget.product.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: themeController.isDarkMode
                        ? Colors.grey.shade300
                        : Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(
                themeController.isDarkMode ? Colors.white : Colors.black),
            backgroundColor:
                MaterialStateProperty.all(Theme.of(context).primaryColor),
          ),
          onPressed: () async {
            int? cartId = await cartController
                .getCartId(authController.user.value?.email);

            CartItem cartItem = CartItem(
              id: DateTime.now().millisecondsSinceEpoch,
              product: widget.product,
              quantity: _qty,
              price: widget.product.tags[_selectedTagIndex].price,
              tag: widget.product.tags[_selectedTagIndex],
            );

            cartController.addToCart(cartItem, cartId);

            Get.snackbar(
              "Success",
              "Sản phẩm đã được thêm vào giỏ hàng!",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.withOpacity(0.8),
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            );
          },
          child: const Padding(
            padding: EdgeInsets.all(6.0),
            child: Text(
              'Thêm vào giỏ hàng',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
