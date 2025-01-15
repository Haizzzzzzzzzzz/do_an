import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_grocery/const.dart';
import 'package:my_grocery/controller/cart_controller.dart';
import 'package:my_grocery/controller/controllers.dart';
import 'package:my_grocery/controller/theme_controller.dart';
import 'package:my_grocery/model/cart_item.dart';
import 'package:my_grocery/view/AI/chatbot_screen.dart';
import 'package:my_grocery/view/account/auth/sign_in_screen.dart';
import 'package:my_grocery/view/account/auth/sign_up_screen.dart';
import 'package:my_grocery/view/order/order_screen.dart';

class CartScreen extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();
  final ThemeController themeController = Get.put(ThemeController());

  CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode
          ? themeController.color_darkMode
          : themeController.color_lightMode,
      appBar: AppBar(
        title: const Text(
          'Giỏ Hàng Của Bạn',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: showBottomSheetOptions,
          ),
        ],
      ),
      body: Obx(() {
        if (cartController.isCartLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (cartController.cartItemList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Không có sản phẩm nào trong giỏ hàng.',
                  style: TextStyle(
                    color: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (authController.user.value?.email != null) {
                      await cartController.loadCartItems();
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeController.isDarkMode
                        ? Colors.grey.shade800
                        : Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: authController.user.value?.email != null
                      ? const Text('Tải lại')
                      : const Text('Đăng ký'),
                ),
              ],
            ),
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await cartController.loadCartItems();
                },
                child: ListView.builder(
                  itemCount: cartController.cartItemList.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartController.cartItemList[index];
                    return buildCartItem(cartItem);
                  },
                ),
              ),
            ),
            buildSummarySection(),
          ],
        );
      }),
    );
  }

  Widget buildCartItem(CartItem cartItem) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              cartController.toggleSelection(cartItem);
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: cartController.selectedCartItems.contains(cartItem)
                    ? (themeController.isDarkMode
                        ? Colors.orangeAccent // Màu nền khi được chọn
                        : Colors.orange)
                    : (themeController.isDarkMode
                        ? Colors.grey.shade800 // Màu nền khi không được chọn
                        : Colors.white),
                border: Border.all(
                  color: cartController.selectedCartItems.contains(cartItem)
                      ? (themeController.isDarkMode
                          ? Colors.orange // Màu viền khi được chọn
                          : Colors.orange)
                      : (themeController.isDarkMode
                          ? Colors.grey.shade600 // Màu viền khi không được chọn
                          : Colors.grey),
                  width: 2.0, // Độ dày viền
                ),
                borderRadius: BorderRadius.circular(4), // Bo góc
              ),
              child: cartController.selectedCartItems.contains(cartItem)
                  ? Icon(
                      Icons.check,
                      color: themeController.isDarkMode
                          ? Colors.black
                          : Colors.white,
                      size: 18, // Kích thước biểu tượng
                    )
                  : null, // Không hiển thị biểu tượng khi không được chọn
            ),
          ),
          const SizedBox(width: 16),
          cartItem.product.images.isNotEmpty
              ? Image.network(
                  //'$baseUrl${cartItem.product.images[0]}',//Hồi trước để như này để chạy local
                  cartItem.product.images[0],
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                )
              : const Icon(Icons.image_not_supported, size: 60),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${cartItem.tag?.title}',
                  style: TextStyle(
                    fontSize: 12,
                    color: themeController.isDarkMode
                        ? Colors.grey.shade300
                        : Colors.grey,
                  ),
                ),
                Text(
                  '${NumberFormat('#,##0', 'vi').format(cartItem.price)}₫',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Số lượng: ${cartItem.quantity}',
                  style: TextStyle(
                    fontSize: 14,
                    color: themeController.isDarkMode
                        ? Colors.grey.shade300
                        : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.remove,
                  color: themeController.isDarkMode
                      ? Colors.grey.shade300
                      : Colors.grey,
                ),
                onPressed: () {
                  if (cartItem.quantity > 1) {
                    cartController.updateCartItemQuantity(
                        cartItem, cartItem.quantity - 1);
                  }
                },
              ),
              Text(
                '${cartItem.quantity}',
                style: TextStyle(
                  fontSize: 16,
                  color: themeController.isDarkMode
                      ? Colors.grey.shade300
                      : Colors.black,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.add,
                  color: themeController.isDarkMode
                      ? Colors.grey.shade300
                      : Colors.grey,
                ),
                onPressed: () {
                  cartController.updateCartItemQuantity(
                      cartItem, cartItem.quantity + 1);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSummarySection() {
    double total = cartController.cartItemList
        .where((item) => cartController.isSelected(item))
        .fold(0, (sum, item) => sum + (item.price * item.quantity));

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: themeController.isDarkMode ? Colors.grey.shade900 : Colors.white,
        boxShadow: [
          BoxShadow(
            color: themeController.isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tổng tiền: ${NumberFormat('#,##0', 'vi').format(total)}₫',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: themeController.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Get.to(() => OrderFormScreen());
            },
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
                backgroundColor: Colors.orange),
            child: Text(
              'Đặt Hàng',
              style: TextStyle(
                  color: themeController.isDarkMode
                      ? themeController.color_darkMode
                      : themeController.color_lightMode,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void showBottomSheetOptions() {
    showModalBottomSheet(
      context: Get.context!,
      backgroundColor:
          themeController.isDarkMode ? Colors.grey.shade900 : Colors.white,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Obx(() => IconButton(
                          onPressed: () {
                            cartController.toggleSelectAll();
                          },
                          icon: Icon(
                            Icons.check,
                            color: cartController.areAllSelected()
                                ? Colors.green
                                : Colors.grey,
                          ),
                        )),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: analyzeSelectedProducts,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeController.isDarkMode
                          ? Colors.grey.shade800
                          : Theme.of(context).primaryColor,
                    ),
                    child: const Text('So sánh AI'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      final selectedItems = cartController.cartItemList
                          .where((item) =>
                              cartController.selectedCartItems.contains(item))
                          .toList();
                      if (selectedItems.isEmpty) {
                        Get.snackbar("No Items Selected",
                            "Please select items to remove.");
                        return;
                      }

                      await cartController.removeSelectedItems(selectedItems);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeController.isDarkMode
                          ? Colors.grey.shade800
                          : Colors.white,
                    ),
                    child: const Text('Xóa'),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void analyzeSelectedProducts() {
    final selectedTitles = cartController.cartItemList
        .where((item) => cartController.isSelected(item))
        .map((item) => item.product.name)
        .toList();

    if (selectedTitles.isNotEmpty) {
      Get.to(() => ChatBotScreen(selectedTitles: selectedTitles));
    } else {
      Get.snackbar(
        "No Products Selected",
        "Please select products to analyze.",
      );
    }
  }
}
