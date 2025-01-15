import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_grocery/controller/theme_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());

    const String facebookUrl = "https://www.facebook.com/haideptraikhongtivet/";
    const String tiktokUrl = "https://www.tiktok.com/@justmikeandtroc/";

    Future<void> _launchUrl(String url) async {
      final String intentUrl = "googlechrome://navigate?url=$url";
      final Uri uri = Uri.parse(intentUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw "Không thể mở liên kết $url";
      }
    }

    return Scaffold(
      backgroundColor: themeController.isDarkMode
          ? themeController.color_darkMode
          : themeController.color_lightMode,
      appBar: AppBar(
        title: const Text(
          'Giới Thiệu Về Z Store',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo hoặc Hình ảnh
              themeController.isDarkMode
                  ? Image.asset(
                      'assets/logo_darkmode.png',
                      fit: BoxFit.contain,
                    )
                  : Image.asset(
                      'assets/logo_lightmode.png',
                      fit: BoxFit.contain,
                    ),
              const SizedBox(height: 16),
              // Tiêu đề
              Center(
                child: Text(
                  'Chào Mừng Đến Với Z Store',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              // Giới thiệu
              Text(
                'Z Store là ứng dụng mua sắm trực tuyến hàng đầu, cung cấp đa dạng các sản phẩm từ thời trang, '
                'điện tử, đồ gia dụng đến phụ kiện và nhiều hơn thế nữa. Với trải nghiệm người dùng mượt mà '
                'và dịch vụ khách hàng tận tâm, chúng tôi cam kết mang lại sự tiện lợi, thú vị và đáng tin cậy cho bạn.',
                style: TextStyle(
                  fontSize: 16,
                  color: themeController.isDarkMode
                      ? Colors.grey.shade300
                      : Colors.black54,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              // Sứ mệnh
              Text(
                'Sứ Mệnh',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color:
                      themeController.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Z Store cam kết mang đến cho khách hàng những sản phẩm chất lượng cao với giá cả hợp lý. '
                'Chúng tôi luôn nỗ lực để mang lại trải nghiệm mua sắm tốt nhất và đáp ứng mọi nhu cầu của khách hàng.',
                style: TextStyle(
                  fontSize: 16,
                  color: themeController.isDarkMode
                      ? Colors.grey.shade300
                      : Colors.black54,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              // Tầm nhìn
              Text(
                'Tầm Nhìn',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color:
                      themeController.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Z Store đặt mục tiêu trở thành nền tảng thương mại điện tử hàng đầu, nổi bật với sự đổi mới, '
                'uy tín và sự hài lòng của khách hàng. Chúng tôi hướng tới việc tích hợp công nghệ tiên tiến như trí tuệ nhân tạo '
                'để nâng cao trải nghiệm người dùng và trở thành một phần không thể thiếu trong cuộc sống hàng ngày của mọi người.',
                style: TextStyle(
                  fontSize: 16,
                  color: themeController.isDarkMode
                      ? Colors.grey.shade300
                      : Colors.black54,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              // Thông tin liên hệ
              Divider(
                color: themeController.isDarkMode
                    ? Colors.grey.shade600
                    : Colors.grey,
              ),
              Text(
                'Thông Tin Liên Hệ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color:
                      themeController.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Địa Chỉ: Chùa Hà, Khu đô thị VCI, Vĩnh Yên, Vĩnh Phúc 280000',
                style: TextStyle(
                  fontSize: 16,
                  color: themeController.isDarkMode
                      ? Colors.grey.shade300
                      : Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Số Điện Thoại: 0967649779',
                style: TextStyle(
                  fontSize: 16,
                  color: themeController.isDarkMode
                      ? Colors.grey.shade300
                      : Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Email: lienhe@trungtamnoithatthluxury.shop',
                style: TextStyle(
                  fontSize: 16,
                  color: themeController.isDarkMode
                      ? Colors.grey.shade300
                      : Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              // Nút Mạng Xã Hội
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _launchUrl(facebookUrl),
                    child: const CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 30,
                      child: Icon(
                        Icons.facebook,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Nút TikTok
                  GestureDetector(
                    onTap: () => _launchUrl(tiktokUrl),
                    child: const CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 30,
                      child: Icon(
                        Icons.tiktok,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
