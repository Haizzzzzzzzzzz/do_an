import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_grocery/controller/order_controller.dart';
import 'package:my_grocery/controller/theme_controller.dart';

class MyOrderScreen extends StatelessWidget {
  MyOrderScreen({super.key});

  final OrderController orderController = Get.put(OrderController());
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    // Fetch orders khi màn hình được tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      orderController.fetchOrders();
    });

    return Scaffold(
      backgroundColor: themeController.isDarkMode
          ? themeController.color_darkMode
          : themeController.color_lightMode,
      appBar: AppBar(
        title: const Text(
          "Đơn Hàng Của Bạn",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        // backgroundColor: themeController.isDarkMode
        //     ? Colors.grey.shade900
        //     : Theme.of(context).primaryColor,
      ),
      body: Obx(() {
        if (orderController.orderList.isEmpty) {
          return Center(
            child: Text(
              "Hiện chưa có đơn hàng nào được đặt",
              style: TextStyle(
                color: themeController.isDarkMode ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: orderController.orderList.length,
          itemBuilder: (context, index) {
            final order = orderController.orderList[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: themeController.isDarkMode
                  ? Colors.grey.shade800
                  : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mã đơn hàng
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Order Number:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: themeController.isDarkMode
                                ? Colors.orange.shade200
                                : Colors.orange,
                          ),
                        ),
                        Text(
                          order.orderNumber,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: themeController.isDarkMode
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Tổng giá
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Price:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: themeController.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        Text(
                          order.totalPrice > 10
                              ? "\$${order.totalPrice.toStringAsFixed(2)}"
                              : "\$${order.totalPrice.toStringAsFixed(2)} TON",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Trạng thái
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Status:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: themeController.isDarkMode
                                ? Colors.blue.shade200
                                : Colors.blue,
                          ),
                        ),
                        Text(
                          order.status,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: _getStatusColor(order.status),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Địa chỉ giao hàng
                    Text(
                      "Shipping Address:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: themeController.isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey,
                      ),
                    ),
                    Text(
                      order.shippingAddress,
                      style: TextStyle(
                        fontSize: 14,
                        color: themeController.isDarkMode
                            ? Colors.white70
                            : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Phương thức thanh toán:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: themeController.isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey,
                      ),
                    ),
                    Text(
                      order.payment,
                      style: TextStyle(
                        fontSize: 14,
                        color: themeController.isDarkMode
                            ? Colors.white70
                            : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Sản phẩm
                    Divider(
                      color: themeController.isDarkMode
                          ? Colors.white70
                          : Colors.black87,
                    ),
                    Text(
                      "Products:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: themeController.isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.orderDetails,
                      style: TextStyle(
                        fontSize: 14,
                        color: themeController.isDarkMode
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(
                      thickness: 1.5,
                      color: Colors.grey,
                    ),
                    // Ngày tạo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Created At:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: themeController.isDarkMode
                                ? Colors.grey.shade400
                                : Colors.grey,
                          ),
                        ),
                        Text(
                          "${order.createdAt}",
                          style: TextStyle(
                            fontSize: 14,
                            color: themeController.isDarkMode
                                ? Colors.white70
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Completed":
        return Colors.green;
      case "Pending":
        return Colors.orange;
      case "Cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
