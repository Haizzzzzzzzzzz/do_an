import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_grocery/const.dart';
import 'package:my_grocery/controller/controllers.dart';

class RemoteCartService {
  var client = http.Client();
  var remoteUrl = '$baseUrl/api/carts'; // Đường dẫn API cho giỏ hàng

  // Lấy thông tin giỏ hàng của người dùng theo email
  Future<dynamic> getCart(String? email) async {
    var response = await client.get(Uri.parse(
        '$remoteUrl?filters[status][\$eq]=${authController.user.value?.email}&populate=cart_items,cart_items.product,cart_items.product.tags,cart_items.tag,cart_items.product.images'));
    print("responseaaaaa: $response");
    return response;
  }

  // Lấy tất cả các sản phẩm trong giỏ hàng theo trạng thái
  Future<http.Response> getCartItemsByStatus(String status) async {
    var response = await client.get(Uri.parse(
        '$remoteUrl?filters[status][\$eq]=${authController.user.value?.email}&populate=cart_items'));
    return response;
  }

  // Thêm sản phẩm vào giỏ hàng
  Future<dynamic> addToCart(int? cartId, int productId, int quantity,
      double price, int? tagId) async {
    var body = jsonEncode({
      "data": {
        "cart": cartId, // Sử dụng ID giỏ hàng
        "product": productId,
        "quantity": quantity,
        "price": price,
        "tag": tagId
      }
    });

    var response = await client.post(
      Uri.parse(
          '$baseUrl/api/cart-products'), // Đảm bảo đúng endpoint cho CartItem
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );

    print("body response add to cart: $body");
    return response;
  }

  // Cập nhật trạng thái của giỏ hàng
  Future<void> updateCartStatus(String cartId, String status) async {
    var body = {"status": status};
    var response = await client.put(
      Uri.parse('$baseUrl/api/carts/$cartId'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update cart status');
    }
  }

  // Phương thức cập nhật số lượng sản phẩm trong giỏ hàng
  Future<void> updateCartItem(int cartItemId, int quantity) async {
    var body = jsonEncode({
      "data": {
        "quantity": quantity,
      }
    });

    var response = await client.put(
      Uri.parse(
          '$baseUrl/api/cart-products/$cartItemId'), // API endpoint để cập nhật giỏ hàng
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update cart item');
    }
  }

  // Xóa sản phẩm khỏi giỏ hàng
  Future<dynamic> removeFromCart(int cartItemId) async {
    var response = await client.delete(
      Uri.parse('$baseUrl/api/cart-products/$cartItemId'),
    );

    return response;
  }

  // Hàm để xóa từng sản phẩm trong giỏ hàng theo ID sản phẩm
  Future<void> deleteCartItem(int cartItemId) async {
    var response = await client.delete(
      Uri.parse('$baseUrl/api/cart-products/$cartItemId'),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to delete cart item with id: $cartItemId");
    }
  }
}
