import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_grocery/const.dart';
import 'package:my_grocery/controller/controllers.dart';

class RemoteOrderService {
  var client = http.Client();
  var remoteUrl = '$baseUrl/api/orders'; // Đường dẫn API cho đơn hàng

  // Gửi yêu cầu tạo đơn hàng lên API
  Future<http.Response> createOrder(String body) async {
    var response = await client.post(
      Uri.parse(remoteUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );
    return response;
  }

  Future<Map<String, dynamic>> getOrders() async {
    final url = Uri.parse(
        '$remoteUrl/?filters[customer][\$eq]=${authController.user.value?.email}&populate=order_items,order_items.images');

    try {
      final response = await http.get(
        url,
      );

      if (response.statusCode == 200) {
        // Parse JSON response
        final Map<String, dynamic> decodedData = jsonDecode(response.body);
        return decodedData; // Return the parsed JSON as Map<String, dynamic>
      } else {
        throw Exception("Failed to fetch orders: ${response.body}");
      }
    } catch (e) {
      print("Error fetching orders: $e");
      rethrow;
    }
  }
}
