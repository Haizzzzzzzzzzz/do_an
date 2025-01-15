import 'package:my_grocery/model/product.dart';

class Order {
  final int id;
  final String orderNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double totalPrice;
  final String status;
  final String fullName;
  final String shippingAddress;
  final String recipientEmail;
  final String recipientPhone;
  final String customer;
  final String payment;
  final List<Product> products;
  final String orderDetails;

  Order({
    required this.id,
    required this.orderNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.totalPrice,
    required this.status,
    required this.fullName,
    required this.shippingAddress,
    required this.recipientEmail,
    required this.recipientPhone,
    required this.customer,
    required this.payment,
    required this.products,
    required this.orderDetails,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        id: json['id'] ?? 0, // ID đơn hàng
        orderNumber: json['order_number'] ?? '', // Số đơn hàng
        createdAt:
            DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
        updatedAt:
            DateTime.parse(json['updatedAt'] ?? DateTime.now().toString()),
        totalPrice: _parseTotalPrice(json['total_price']), // Giá trị tổng
        status: json['status'] ?? 'Unknown', // Trạng thái
        fullName: json['full_name'] ?? '', // Trạng thái
        shippingAddress: json['shipping_address'] ?? '', // Địa chỉ giao hàng
        recipientEmail: json['recipient_email'] ?? '', // Email người nhận
        recipientPhone: json['recipient_phone'] ?? '', // Số điện thoại
        customer: json['customer'] ?? '', // Khách hàng
        payment: json['payment'] ?? '', // Phương thức thanh toán
        products: _parseProducts(json['products']), // Danh sách sản phẩm
        orderDetails: json['order_details'] ?? '');
  }

  /// Hàm xử lý giá trị total_price
  static double _parseTotalPrice(dynamic value) {
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    } else if (value is num) {
      return value.toDouble();
    }
    return 0.0; // Giá trị mặc định nếu không hợp lệ
  }

  /// Hàm xử lý danh sách sản phẩm products
  static List<Product> _parseProducts(dynamic items) {
    if (items is List) {
      return items
          .map((item) => Product.fromJson(item))
          .toList(); // Sử dụng fromJson
    }
    return []; // Trả về danh sách rỗng nếu không hợp lệ
  }
}
