import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_grocery/const.dart';
import 'package:my_grocery/controller/cart_controller.dart';
import 'package:my_grocery/controller/controllers.dart';
import 'package:my_grocery/controller/order_controller.dart';
import 'package:my_grocery/controller/theme_controller.dart';
import 'package:my_grocery/model/cart_item.dart';
import 'package:my_grocery/service/momo.dart';
import 'package:my_grocery/view/order/PaymentResultScreen.dart';
import 'package:http/http.dart' as http;
import 'package:my_grocery/view/order/crypto_wallet_screen.dart';

class OrderFormScreen extends StatefulWidget {
  final String? customId; // Nhận customId từ ngoài
  const OrderFormScreen({super.key, this.customId});

  @override
  _OrderFormScreenState createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  final CartController cartController = Get.find<CartController>();
  final ThemeController themeController = Get.find<ThemeController>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final orderNumber = "ORD-${DateTime.now().millisecondsSinceEpoch}";

  @override
  void dispose() {
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.customId != null) {
      // Gọi API để lấy thông tin sản phẩm và hiển thị
      cartController.loadCartItems();
      fetchProductDetails(widget.customId!);
    }
  }

  Future<void> fetchProductDetails(String customId) async {
    String serverUrl =
        "$baseUrl/api/customs?filters[id][\$eq]=$customId&populate=image_custom";

    final response = await http.get(Uri.parse(serverUrl));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      // debugPrint("Chi tiết sản phẩm: $jsonResponse");

      final productData = jsonResponse['data'][0]['attributes'];
      final imageCustomData = productData['image_custom'];

      if (imageCustomData != null && imageCustomData['data'] != null) {
        final imageUrl = imageCustomData['data']['attributes']['url'];
        debugPrint('URL của ảnh: $baseUrl$imageUrl');
      } else {
        debugPrint('Không có ảnh liên kết với sản phẩm.');
      }
    } else {
      debugPrint('Không thể lấy chi tiết sản phẩm: ${response.statusCode}');
      debugPrint('Chi tiết lỗi: ${response.body}');
    }
  }

  void _placeOrder() async {
    print("aaa");

    if (_formKey.currentState!.validate()) {
      String customer = authController.user.value?.email ?? "Guest";
      List<CartItem> selectedItems = cartController.cartItemList
          .where((item) => cartController.isSelected(item))
          .toList();

      if (selectedItems.isEmpty && widget.customId == null) {
        Get.snackbar("No Items Selected", "Please select items to order.");
        return;
      } else if (widget.customId != null && selectedItems.isEmpty) {
        await OrderController.instance.clearCartAfterOrder(
          customer,
          selectedItems.map((item) => item.id).toList(),
        );

        print("widget.customId: ${widget.customId}");
        String serverUrl =
            "$baseUrl/api/customs?filters[id][\$eq]=${widget.customId}&populate=image_custom";

        final response = await http.get(Uri.parse(serverUrl));

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          // debugPrint("Chi tiết sản phẩm: $jsonResponse");

          final productData = jsonResponse['data'][0]['attributes'];
          final imageCustomData = productData['image_custom'];

          final phoneModel = productData['phoneModel'];
          final userCustom = productData['user_custom'];
          var imageUrl_custom = "";

          if (imageCustomData != null && imageCustomData['data'] != null) {
            final imageUrl = imageCustomData['data']['attributes']['url'];
            debugPrint('URL của ảnh: $baseUrl$imageUrl');
            //imageUrl_custom = '$baseUrl$imageUrl';//Hồi trước để như này để chạy local
            imageUrl_custom = '$imageUrl';
          } else {
            debugPrint('Không có ảnh liên kết với sản phẩm.');
          }

          await OrderController.instance.createOrderCustom(
            order_number: orderNumber,
            price: 50000,
            idCustom: widget.customId,
            phoneModel: phoneModel,
            userCustom: userCustom,
            imageUrl: imageUrl_custom,
            fullName: _fullnameController.text,
            shippingAddress: _addressController.text,
            recipientEmail: _emailController.text,
            recipientPhone: _phoneController.text,
            payment: "cod - CUSTOM",
          );

          Get.snackbar(
            'Success',
            'Đơn hàng của bạn đã được đặt thành công!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );

          _addressController.clear();
          _emailController.clear();
          _phoneController.clear();

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PaymentResultScreen(
                        success: true,
                      )));
          return;
        } else {
          debugPrint('Không thể lấy chi tiết sản phẩm: ${response.statusCode}');
          debugPrint('Chi tiết lỗi: ${response.body}');
        }
      }

      await OrderController.instance.createOrder(
        order_number: orderNumber,
        customerId: customer,
        fullName: _fullnameController.text,
        shippingAddress: _addressController.text,
        recipientEmail: _emailController.text,
        recipientPhone: _phoneController.text,
        payment: "cod",
        selectedItems: selectedItems,
      );

      Get.snackbar(
        'Success',
        'Đơn hàng của bạn đã được đặt thành công!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      await OrderController.instance.clearCartAfterOrder(
        customer,
        selectedItems.map((item) => item.id).toList(),
      );

      await cartController.loadCartItems();

      _addressController.clear();
      _emailController.clear();
      _phoneController.clear();

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const PaymentResultScreen(
                    success: true,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = themeController.isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đặt Hàng',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: isDarkMode
          ? themeController.color_darkMode
          : themeController.color_lightMode,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Họ và tên', isDarkMode),
              _buildTextField(
                controller: _fullnameController,
                hint: 'Nhập họ và tên của bạn',
                icon: Icons.person,
                isDarkMode: isDarkMode,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Làm ơn nhập họ và tên';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              _buildSectionTitle('Địa chỉ', isDarkMode),
              _buildTextField(
                controller: _addressController,
                hint: 'Nhập địa chỉ giao hàng của bạn',
                icon: Icons.location_on,
                isDarkMode: isDarkMode,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              _buildSectionTitle('Email', isDarkMode),
              _buildTextField(
                controller: _emailController,
                hint: 'Nhập địa chỉ email của bạn',
                icon: Icons.email,
                isDarkMode: isDarkMode,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              _buildSectionTitle('Số điện thoại', isDarkMode),
              _buildTextField(
                controller: _phoneController,
                hint: 'Nhập số điện thoại của bạn',
                icon: Icons.phone,
                isDarkMode: isDarkMode,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              Obx(() {
                double total = cartController.cartItemList
                    .where((item) => cartController.isSelected(item))
                    .fold(0, (sum, item) => sum + (item.price * item.quantity));
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.customId == null
                          ? 'Tổng tiền: ${NumberFormat('#,##0', 'vi').format(total)} đ'
                          : 'Tổng tiền: 50.000 đ',
                      style: TextStyle(
                        fontSize: 18,
                        color: isDarkMode ? Colors.orangeAccent : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        _placeOrder();
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: isDarkMode
                              ? themeController.color_lightMode
                              : Colors.orange),
                      child: Center(
                          child: Text(
                        'Thanh Toán Khi Nhận Hàng',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? Colors.orange
                              : themeController.color_lightMode,
                        ),
                      )),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Get.to(() => MoMoPaymentScreen(
                                order_number: orderNumber,
                                customId: widget.customId,
                                totalAmount:
                                    widget.customId == null ? total : 50000,
                                name: _fullnameController.text,
                                address: _addressController.text,
                                email: _emailController.text,
                                phoneNumber: _phoneController.text,
                              ));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[400],
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Center(
                          child: Text(
                        'Thanh Toán Với Ví MoMo',
                        style: TextStyle(
                            color: isDarkMode
                                ? themeController.color_lightMode
                                : themeController.color_darkMode,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                    const SizedBox(height: 10),
                    widget.customId != null
                        ? ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Get.to(() => CryptoWalletScreen(
                                      order_number: orderNumber,
                                      customId: widget.customId,
                                      totalAmount: 50000,
                                      name: _fullnameController.text,
                                      address: _addressController.text,
                                      email: _emailController.text,
                                      phoneNumber: _phoneController.text,
                                    ));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Center(
                                child: Text(
                              'Thanh Toán Bằng Crypto',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                          )
                        : Container(),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color:
              isDarkMode ? Colors.orangeAccent : themeController.color_darkMode,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool isDarkMode,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon,
            color: isDarkMode
                ? Colors.orangeAccent
                : Theme.of(context).primaryColor),
        filled: true,
        fillColor:
            isDarkMode ? Colors.grey.shade800 : themeController.color_lightMode,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDarkMode
                ? Colors.orangeAccent
                : Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
