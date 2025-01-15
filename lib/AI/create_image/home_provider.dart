import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:my_grocery/const.dart'; // Để sử dụng MediaType
import 'package:image/image.dart' as img;
import 'package:my_grocery/view/order/order_screen.dart';

final homeProvider =
    ChangeNotifierProvider<HomeProvider>((ref) => HomeProvider());

class HomeProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isSearching = false;
  Uint8List? imageData;

  void loadingChange(bool val) {
    isLoading = val;
    notifyListeners();
  }

  void searchingChange(bool val) {
    isSearching = val;
    notifyListeners();
  }

  Future<dynamic> textToImage(String prompt, BuildContext context) async {
    String engineId = "stable-diffusion-v1-6";
    String apiHost = 'https://api.stability.ai';
    String apiKey = 'sk-J21Vn5prrBIYZtj6Z6J2LJAb0qvGjXgZhw1og0peaWTCBCyb';
    debugPrint(prompt);
    final response = await http.post(
        Uri.parse('$apiHost/v1/generation/$engineId/text-to-image'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "image/png",
          "Authorization": "Bearer $apiKey"
        },
        body: jsonEncode({
          "text_prompts": [
            {
              "text": prompt,
              "weight": 1,
            }
          ],
          "cfg_scale": 7,
          "height": 1024,
          "width": 1024,
          "samples": 1,
          "steps": 30,
        }));

    if (response.statusCode == 200) {
      try {
        debugPrint(response.statusCode.toString());
        imageData = response.bodyBytes;
        loadingChange(true);
        searchingChange(false);
        notifyListeners();
      } on Exception {
        debugPrint("failed to generate image");
      }
    } else {
      debugPrint("failed to generate image");
    }
  }

  Future<void> fetchProductDetails(String productId) async {
    String serverUrl =
        "$baseUrl/api/customs?filters[id][\$eq]=$productId&populate=image_custom";

    final response = await http.get(Uri.parse(serverUrl));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      // debugPrint("Chi tiết sản phẩm: $jsonResponse");

      final productData = jsonResponse['data'][0]['attributes'];
      final imageCustomData = productData['image_custom'];

      if (imageCustomData != null && imageCustomData['data'] != null) {
        final imageUrl = imageCustomData['data']['attributes']['url'];
        //debugPrint('URL của ảnh: $baseUrl$imageUrl');//Hồi trước để như này để chạy local
        debugPrint('URL của ảnh: $imageUrl');
      } else {
        debugPrint('Không có ảnh liên kết với sản phẩm.');
      }
    } else {
      debugPrint('Không thể lấy chi tiết sản phẩm: ${response.statusCode}');
      debugPrint('Chi tiết lỗi: ${response.body}');
    }
  }

  Future<void> saveImageAndCreateOrder(BuildContext context, String idCustom,
      String phoneModel, String userCustom, Uint8List imageBytes) async {
    EasyLoading.show(
      status: 'Loading...',
      dismissOnTap: false,
    );
    String serverUrl = "$baseUrl/api/customs"; // Endpoint lưu sản phẩm

    var request = http.MultipartRequest('POST', Uri.parse(serverUrl));
    request.fields['data'] = jsonEncode({
      "id_custom": idCustom,
      "phoneModel": phoneModel,
      "user_custom": userCustom,
    });

    request.files.add(http.MultipartFile.fromBytes(
      'files.image_custom',
      imageBytes,
      filename: 'ai_image.png',
      contentType: MediaType('image', 'png'),
    ));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = jsonDecode(await response.stream.bytesToString());
      debugPrint("Lưu ảnh và dữ liệu thành công: $responseData");

      final productId = responseData['data']['id'];

      // Điều hướng đến OrderFormScreen với productId
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderFormScreen(customId: productId.toString()),
        ),
      );
      EasyLoading.dismiss();
    } else {
      debugPrint('Lưu ảnh thất bại: ${response.statusCode}');
      if (response.stream != null) {
        try {
          final errorDetails = await response.stream.bytesToString();
          debugPrint('Chi tiết lỗi: $errorDetails');
        } catch (e) {
          debugPrint('Không thể đọc chi tiết lỗi từ response.stream: $e');
        }
      } else {
        debugPrint('Không có stream trong response.');
      }
    }
  }
}
