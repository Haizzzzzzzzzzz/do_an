import 'dart:convert';
import 'dart:ffi';
import 'package:get/get.dart';
import 'package:my_grocery/controller/cart_controller.dart';
import 'package:my_grocery/model/cart_item.dart';
import 'package:my_grocery/model/order.dart';
import 'package:my_grocery/model/product.dart';
import 'package:my_grocery/model/tag.dart';
import 'package:my_grocery/service/remote_service/remote_order_service.dart';

class OrderController extends GetxController {
  static OrderController instance = Get.find();
  final CartController cartController =
      Get.find(); // Sử dụng CartController để lấy giỏ hàng hiện tại
  RxBool isOrderProcessing = false.obs; // Trạng thái xử lý đơn hàng
  RxList<Order> orderList = <Order>[].obs; // Danh sách đơn hàng
  RxBool isLoading = false.obs; // Trạng thái loading

  // Hàm để tạo đơn hàng và gửi thông tin lên API
  Future<void> createOrder({
    required String order_number, // ID của đơn hàng
    required String customerId, // ID của khách hàng
    required String fullName, // Địa chỉ giao hàng
    required String shippingAddress, // Địa chỉ giao hàng
    required String recipientEmail, // Email người nhận
    required String recipientPhone, // Số điện thoại người nhận
    required String payment, // Phương thức thanh toán
    required List<CartItem> selectedItems, // Các sản phẩm đã chọn
  }) async {
    try {
      isOrderProcessing(true);

      // Tạo danh sách các product IDs từ các sản phẩm đã chọn
      List<int> productIds =
          selectedItems.map((item) => item.product.id).toList();

      // Tạo danh sách orderItems chỉ gồm tên sản phẩm + tag và số lượng
      List<Map<String, dynamic>> orderItems = selectedItems.map((item) {
        return {
          "product_name": "${item.product.name} - ${item.tag!.title}",
          "quantity": item.quantity,
        };
      }).toList();

      String formattedOrderItems = orderItems.map((item) {
        return "${item['product_name']} x ${item['quantity']}";
      }).join("\n\n"); // Thêm hai dòng trống giữa các sản phẩm

      // Tính tổng giá trị đơn hàng từ các sản phẩm đã chọn
      double totalPrice = selectedItems.fold(
        0,
        (sum, item) => sum + (item.price * item.quantity),
      );

      // Tạo payload gửi lên server
      var body = jsonEncode({
        "data": {
          "order_number": order_number, // Tạo mã đơn hàng duy nhất
          "customer": customerId, // ID khách hàng
          "order_items": productIds, // Gửi danh sách ID sản phẩm
          "order_details": formattedOrderItems,
          "total_price": totalPrice, // Tổng giá trị đơn hàng
          "status": "Pending", // Trạng thái đơn hàng ban đầu
          "full_name": fullName, // Trạng thái đơn hàng ban đầu
          "shipping_address": shippingAddress, // Địa chỉ giao hàng
          "recipient_email": recipientEmail, // Email người nhận
          "recipient_phone": recipientPhone, // Số điện thoại người nhận
          "payment": payment // Phương thức thanh toán
        }
      });

      // Gửi POST request tới API để tạo đơn hàng
      var response = await RemoteOrderService().createOrder(body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Order created successfully!");
      } else {
        print("Failed to create order: ${response.body}");
      }
    } catch (e) {
      print("Error creating order: $e");
    } finally {
      isOrderProcessing(false); // Dừng trạng thái xử lý sau khi hoàn tất
    }
  }

  Future<void> fetchOrders() async {
    isLoading(true);

    // Gọi API để lấy danh sách đơn hàng
    var response = await RemoteOrderService().getOrders();

    if (response.containsKey('data')) {
      var ordersData = response['data'] as List<dynamic>;

      // Chuyển dữ liệu JSON thành danh sách Order
      var orders = ordersData.map((order) {
        var attributes = order['attributes'];
        print("attributes $attributes");
        // Parse sản phẩm trong order_items
        var orderItemsData = attributes['order_items']['data'] as List<dynamic>;
        var products = orderItemsData.map((item) {
          var itemAttributes = item['attributes'];

          return Product(
            id: item['id'],
            name: itemAttributes['name'],
            description: itemAttributes['description'],
            images: (itemAttributes['images'] is List) // Kiểm tra kiểu dữ liệu
                ? (itemAttributes['images'] as List)
                    .map((image) => image.toString())
                    .toList()
                : [], // Nếu không phải List, trả về danh sách rỗng
            tags: (itemAttributes['tags'] is List)
                ? (itemAttributes['tags'] as List)
                    .map((tag) => Tag.fromJson(tag))
                    .toList()
                : [],
          );
        }).toList();

        // Tạo Order từ dữ liệu
        return Order(
          id: order['id'],
          orderNumber: attributes['order_number'],
          createdAt: DateTime.parse(attributes['createdAt']),
          updatedAt: DateTime.parse(attributes['updatedAt']),
          totalPrice: attributes['total_price'].toDouble(),
          status: attributes['status'],
          fullName: attributes['full_name'],
          shippingAddress: attributes['shipping_address'],
          recipientEmail: attributes['recipient_email'],
          recipientPhone: attributes['recipient_phone'],
          customer: attributes['customer'],
          payment: attributes['payment'],
          products: products.toList(),
          orderDetails: attributes['order_details'],
        );
      }).toList();

      // Cập nhật danh sách orders
      orderList.assignAll(orders);
    } else {
      print("Error: 'data' field missing in API response");
    }
  }

  Future<void> createOrderCustom({
    required String? order_number,
    required double price,
    required String? idCustom,
    required String phoneModel,
    required String userCustom,
    required String imageUrl, // URL ảnh custom từ server
    required String fullName, // URL ảnh custom từ server
    required String shippingAddress,
    required String recipientEmail,
    required String recipientPhone,
    required String payment,
  }) async {
    try {
      isOrderProcessing(true);
      print("Đã order custom");
      // Tạo mã đơn hàng duy nhất

      // Chi tiết sản phẩm custom
      String orderDetails = "Phân loại: Ốp điện thoại $phoneModel\n$imageUrl";

      // Tạo payload gửi lên server
      var body = jsonEncode({
        "data": {
          "order_number": order_number,
          "customer": userCustom, // Dùng userCustom làm customer
          "order_details": orderDetails,
          "total_price": price, // Giá trị mặc định
          "status": "Pending",
          "full_name": fullName,
          "shipping_address": shippingAddress,
          "recipient_email": recipientEmail,
          "recipient_phone": recipientPhone,
          "payment": payment,
          "image_url": imageUrl, // Lưu URL ảnh nếu cần
        }
      });

      // Gửi POST request tới API để tạo đơn hàng
      var response = await RemoteOrderService().createOrder(body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Custom Order created successfully!");
      } else {
        print("Failed to create custom order: ${response.body}");
      }
    } catch (e) {
      print("Error creating custom order: $e");
    } finally {
      isOrderProcessing(false); // Dừng trạng thái xử lý sau khi hoàn tất
    }
  }

  // Hàm để xóa giỏ hàng sau khi đơn hàng đã được tạo
  Future<void> clearCartAfterOrder(
      String customer, List<int> selectedItemIds) async {
    await cartController.clearCartItemsByStatus(customer, selectedItemIds);
  }
}
