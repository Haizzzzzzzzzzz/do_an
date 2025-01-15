import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:my_grocery/const.dart';
import 'package:my_grocery/controller/cart_controller.dart';
import 'package:my_grocery/controller/controllers.dart';
import 'package:my_grocery/controller/order_controller.dart';
import 'package:my_grocery/model/cart_item.dart';
import 'package:my_grocery/view/order/PaymentResultScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';

class MoMoPaymentScreen extends StatefulWidget {
  final String order_number;
  final double totalAmount;
  final String name;
  final String address;
  final String email;
  final String phoneNumber;
  final String? customId;

  const MoMoPaymentScreen({
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
  State<MoMoPaymentScreen> createState() => _MoMoPaymentScreenState();
}

class _MoMoPaymentScreenState extends State<MoMoPaymentScreen> {
  StreamSubscription<String?>? _linkStreamSubscription; // Sửa kiểu dữ liệu
  final CartController cartController = Get.find<CartController>();
  final String partnerCode = 'MOMOBKUN20180529';
  final String accessKey = 'klm05TvNBzhg7h7j';
  final String secretKey = 'at67qH6mk8w5Y1nAyMoYKMWACiEi2bsa';
  final String redirectUrl = 'yourapp://MyApp?form=payment';
  final String ipnUrl =
      'https://webhook.site/b3088a6a-2d17-4f8d-a383-71389a6c600b';

  @override
  void initState() {
    super.initState();
    _initiatePayment(); // Bắt đầu thanh toán ngay khi mở màn hình
    _handleIncomingLinks(); // Lắng nghe khi quay lại app
  }

  @override
  void dispose() {
    // Hủy lắng nghe khi thoát khỏi màn hình
    _linkStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initiatePayment() async {
    final String requestId = DateTime.now().millisecondsSinceEpoch.toString();
    final String orderId = requestId;
    final String amount = widget.totalAmount.round().toString();
    const String orderInfo = "Thanh toán qua MoMo";
    const String requestType = "payWithATM";
    final String extraData = jsonEncode({
      "address": widget.address,
      "email": widget.email,
      "phoneNumber": widget.phoneNumber,
    });

    final String rawHash =
        "accessKey=$accessKey&amount=$amount&extraData=$extraData&ipnUrl=$ipnUrl&orderId=$orderId&orderInfo=$orderInfo&partnerCode=$partnerCode&redirectUrl=$redirectUrl&requestId=$requestId&requestType=$requestType";

    final String signature = Hmac(sha256, utf8.encode(secretKey))
        .convert(utf8.encode(rawHash))
        .toString();

    final Map<String, dynamic> paymentInfo = {
      'partnerCode': partnerCode,
      'partnerName': "Test",
      'storeId': "MomoTestStore",
      'requestId': requestId,
      'amount': amount,
      'orderId': orderId,
      'orderInfo': orderInfo,
      'redirectUrl': redirectUrl,
      'ipnUrl': ipnUrl,
      'lang': 'vi',
      'extraData': extraData,
      'requestType': requestType,
      'signature': signature
    };

    final response = await http.post(
      Uri.parse("https://test-payment.momo.vn/v2/gateway/api/create"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(paymentInfo),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final String? payUrl = responseData["payUrl"];
      final String? transactionId = responseData["transId"];

      if (payUrl != null) {
        final String intentUrl = "googlechrome://navigate?url=$payUrl";
        print("payUrl: $payUrl");
        final Uri uri = Uri.parse(intentUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          print("aaaaaaaaaaaaaaa$transactionId");
        } else {
          print("Không thể mở liên kết với Google Chrome");
        }

        // Lưu thông tin thanh toán nếu transactionId tồn tại
        if (transactionId != null) {
          _savePaymentInfo(transactionId);
        }
      } else {
        print("Không thể tạo liên kết thanh toán MoMo");
      }
    } else {
      print("Lỗi khi tạo yêu cầu thanh toán: ${response.body}");
      print("PartnerCode: $partnerCode");
      print("AccessKey: $accessKey");
      print("Amount: $amount");
      print("OrderId: $orderId");
      print("RequestId: $requestId");
      print("OrderInfo: $orderInfo");
      print("RedirectUrl: $redirectUrl");
      print("IpnUrl: $ipnUrl");
      print("ExtraData: $extraData");
      print("RequestType: $requestType");
      print("Signature: $signature");
    }
  }

  Future<void> _handleIncomingLinks() async {
    try {
      // final initialLink = await getInitialLink();
      // if (initialLink != null) {
      //   _processRedirect(initialLink);
      // }

      // Lắng nghe linkStream
      _linkStreamSubscription = linkStream.listen((String? link) {
        if (link != null) {
          _processRedirect(link);
        }
      }, onError: (err) {
        print("Error listening to link stream: $err");
      });
    } catch (e) {
      print('Error processing incoming link: $e');
    }
  }

  void _processRedirect(String link) {
    Uri uri = Uri.parse(link);
    print("uri: $uri");
    String? form = uri.queryParameters['form'];
    print("form: $form");
    if (form == 'payment') {
      String? transactionId = uri.queryParameters['transId'];
      if (transactionId != null) {
        _savePaymentInfo(transactionId);
        // Điều hướng quay lại màn hình kết quả
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => PaymentResultScreen(
              success: true,
              transactionId: transactionId,
            ),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => PaymentResultScreen(success: false),
          ),
        );
      }
    }
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
            price: 50000,
            idCustom: widget.customId,
            phoneModel: phoneModel,
            userCustom: userCustom,
            imageUrl: imageUrl_custom,
            fullName: widget.name,
            shippingAddress: widget.address,
            recipientEmail: widget.email,
            recipientPhone: widget.phoneNumber,
            payment: "momo - CUSTOM",
          );
          Get.snackbar(
            'Thành công',
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
        payment: "momo",
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
    return Scaffold(
      appBar: AppBar(title: const Text('Thanh Toán MoMo')),
      body: const Center(
        child: CircularProgressIndicator(), // Hiển thị trạng thái chờ
      ),
    );
  }
}
