import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_grocery/const.dart';
import 'package:my_grocery/controller/cart_controller.dart';
import 'package:my_grocery/controller/controllers.dart';
import 'package:my_grocery/controller/order_controller.dart';
import 'package:my_grocery/model/cart_item.dart';
import 'package:http/http.dart' as http;
import 'package:my_grocery/view/order/PaymentResultScreen.dart';

class CryptoWalletScreen extends StatefulWidget {
  final String order_number;
  final double totalAmount;
  final String name;
  final String address;
  final String email;
  final String phoneNumber;
  final String? customId;

  const CryptoWalletScreen({
    required this.order_number,
    required this.totalAmount,
    required this.name,
    required this.address,
    required this.email,
    required this.phoneNumber,
    this.customId,
    super.key,
  });

  @override
  _CryptoWalletScreenState createState() => _CryptoWalletScreenState();
}

class _CryptoWalletScreenState extends State<CryptoWalletScreen> {
  final String networkName = "TON";
  final String walletAddress =
      "UQDIJb6MIyXNkQxdYarvkxsr5_oiicqoK90ygXVCvxoVOWsa";
  final String warningMessage =
      "CẢNH BÁO QUAN TRỌNG: Bạn phải sao chép cả địa chỉ TON và comment để đảm bảo nạp tiền thành công. Nếu thiếu một trong hai, tài sản của bạn sẽ bị mất!";
  final CartController cartController = Get.find<CartController>();

  // Hàm sao chép dữ liệu
  void _copyToClipboard(String value, String label) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Đã sao chép $label")),
    );
  }

  void _savePaymentInfo(String transactionId) async {
    print("Lưu thông tin thanh toán:");
    print("Địa chỉ: ${widget.address}");
    print("Email: ${widget.email}");
    print("Số điện thoại: ${widget.phoneNumber}");
    print("Transaction ID: $transactionId");
    print("widget.customId: ${widget.customId}");
    try {
      // Lấy danh sách các sản phẩm được chọn
      List<CartItem> selectedItems = cartController.cartItemList
          .where(
              (item) => cartController.isSelected(item)) // Lọc sản phẩm đã chọn
          .toList();

      if (selectedItems.isEmpty && widget.customId == null) {
        print("Không có sản phẩm nào được chọn để đặt hàng.");
        return;
      } else if (widget.customId != null && selectedItems.isEmpty) {
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
            // imageUrl_custom = '$baseUrl$imageUrl';//Hồi trước để như này để chạy local
            imageUrl_custom = '$imageUrl';
          } else {
            debugPrint('Không có ảnh liên kết với sản phẩm.');
          }
          await OrderController.instance.createOrderCustom(
            order_number: widget.order_number,
            price: 0.1,
            idCustom: widget.customId,
            phoneModel: phoneModel,
            userCustom: userCustom,
            imageUrl: imageUrl_custom,
            fullName: widget.name,
            shippingAddress: widget.address,
            recipientEmail: widget.email,
            recipientPhone: widget.phoneNumber,
            payment: "CRYPTO - CUSTOM",
          );
          Get.snackbar(
            'Success',
            'Đơn hàng của bạn đã được đặt thành công!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
          return;
        }
      }

      // Gọi hàm tạo đơn hàng
      await OrderController.instance.createOrder(
        order_number: widget.order_number,
        customerId: authController.user.value!.email,
        fullName: widget.name,
        shippingAddress: widget.address,
        recipientEmail: widget.email,
        recipientPhone: widget.phoneNumber,
        payment: "CRYPTO",
        selectedItems: selectedItems, // Truyền danh sách sản phẩm đã chọn
      );

      // Xóa các sản phẩm đã đặt hàng khỏi giỏ hàng
      await OrderController.instance.clearCartAfterOrder(
        "Pending",
        selectedItems
            .map((item) => item.id)
            .toList(), // Truyền danh sách ID sản phẩm đã chọn
      );

      print("Order saved and cart cleared successfully!");
    } catch (e) {
      print("Error saving order: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final String comment = widget.order_number;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Thanh Toán Crypto",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  networkName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/crypto_wallet.png', // Thay bằng đường dẫn hình ảnh local
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Thanh toán: 0.1 TON",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildWalletInfoSection("Địa chỉ", walletAddress),
                const SizedBox(height: 10),
                _buildWalletInfoSection("Comment", comment!),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info, color: Colors.white),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          warningMessage,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                _savePaymentInfo(widget.order_number);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => PaymentResultScreen(
                      success: true,
                      transactionId: widget.order_number,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Center(
                  child: Text(
                'Xác Nhận Thanh Toán',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              )),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWalletInfoSection(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment:
            CrossAxisAlignment.start, // Giúp nội dung căn chỉnh tốt hơn
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  maxLines: 3, // Giới hạn dòng để không bị tràn
                  overflow: TextOverflow
                      .ellipsis, // Thêm dấu "..." khi văn bản quá dài
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _copyToClipboard(value, title),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            child: const Text("Sao chép"),
          ),
        ],
      ),
    );
  }
}
