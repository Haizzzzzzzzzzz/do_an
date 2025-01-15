import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_grocery/controller/theme_controller.dart';

class ShippingWarranty extends StatelessWidget {
  const ShippingWarranty({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());

    return Scaffold(
      backgroundColor: themeController.isDarkMode
          ? themeController.color_darkMode
          : themeController.color_lightMode,
      appBar: AppBar(
        title: const Text("Chính Sách Vận Chuyển & Bảo Hành"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                "Chính Sách Vận Chuyển",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color:
                      themeController.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Z Store cam kết cung cấp dịch vụ vận chuyển nhanh chóng, an toàn và tiện lợi cho tất cả các đơn hàng.",
                style: TextStyle(
                  fontSize: 16,
                  color: themeController.isDarkMode
                      ? Colors.grey.shade300
                      : Colors.black87,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),

              // Nội dung chi tiết vận chuyển
              Text(
                "1. Thời Gian Giao Hàng:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      themeController.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "- Khu vực nội thành: 1-2 ngày làm việc.",
                style: TextStyle(
                  fontSize: 16,
                  color: themeController.isDarkMode
                      ? Colors.grey.shade300
                      : Colors.black87,
                ),
              ),
              Text(
                "- Khu vực ngoại thành: 3-5 ngày làm việc.",
                style: TextStyle(
                  fontSize: 16,
                  color: themeController.isDarkMode
                      ? Colors.grey.shade300
                      : Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "2. Phí Vận Chuyển:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      themeController.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "- Miễn phí vận chuyển cho đơn hàng từ 500,000 VNĐ.",
                style: TextStyle(
                  fontSize: 16,
                  color: themeController.isDarkMode
                      ? Colors.grey.shade300
                      : Colors.black87,
                ),
              ),
              Text(
                "- Đơn hàng dưới 500,000 VNĐ sẽ tính phí vận chuyển tùy khu vực, từ 20,000 VNĐ.",
                style: TextStyle(
                  fontSize: 16,
                  color: themeController.isDarkMode
                      ? Colors.grey.shade300
                      : Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "3. Theo Dõi Đơn Hàng:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      themeController.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "- Khách hàng có thể theo dõi tình trạng đơn hàng qua email hoặc ứng dụng Z Store.",
                style: TextStyle(
                  fontSize: 16,
                  color: themeController.isDarkMode
                      ? Colors.grey.shade300
                      : Colors.black87,
                ),
              ),
              const SizedBox(height: 24),

              // Header Bảo hành
              Text(
                "Chính Sách Bảo Hành",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color:
                      themeController.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Z Store luôn đảm bảo quyền lợi của khách hàng với chính sách bảo hành minh bạch và rõ ràng.",
                style: TextStyle(
                  fontSize: 16,
                  color: themeController.isDarkMode
                      ? Colors.grey.shade300
                      : Colors.black87,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),

              // Nội dung chi tiết bảo hành
              Text(
                "1. Điều Kiện Bảo Hành:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      themeController.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "- Sản phẩm còn nguyên tem, hóa đơn mua hàng.",
                style: TextStyle(
                  fontSize: 16,
                  color: themeController.isDarkMode
                      ? Colors.grey.shade300
                      : Colors.black87,
                ),
              ),
              Text(
                "- Lỗi sản phẩm từ nhà sản xuất trong thời gian bảo hành.",
                style: TextStyle(
                  fontSize: 16,
                  color: themeController.isDarkMode
                      ? Colors.grey.shade300
                      : Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "2. Thời Gian Bảo Hành:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      themeController.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "- Sản phẩm được bảo hành trong vòng 12 tháng kể từ ngày mua hàng.",
                style: TextStyle(
                  fontSize: 16,
                  color: themeController.isDarkMode
                      ? Colors.grey.shade300
                      : Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "3. Quy Trình Bảo Hành:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      themeController.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "- Liên hệ đội ngũ hỗ trợ khách hàng qua hotline: 0967649779 hoặc email: lienhe@zstore.vn.",
                style: TextStyle(
                  fontSize: 16,
                  color: themeController.isDarkMode
                      ? Colors.grey.shade300
                      : Colors.black87,
                ),
              ),
              Text(
                "- Gửi sản phẩm đến trung tâm bảo hành của Z Store theo hướng dẫn.",
                style: TextStyle(
                  fontSize: 16,
                  color: themeController.isDarkMode
                      ? Colors.grey.shade300
                      : Colors.black87,
                ),
              ),
              Text(
                "- Z Store sẽ kiểm tra và xử lý bảo hành trong vòng 5-7 ngày làm việc.",
                style: TextStyle(
                  fontSize: 16,
                  color: themeController.isDarkMode
                      ? Colors.grey.shade300
                      : Colors.black87,
                ),
              ),
              const SizedBox(height: 24),

              // Cảm ơn
              Center(
                child: Text(
                  "Cảm ơn quý khách đã tin tưởng và lựa chọn Z Store!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: themeController.isDarkMode
                        ? Colors.green.shade300
                        : Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
