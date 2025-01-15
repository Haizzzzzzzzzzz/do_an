import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_grocery/controller/theme_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);

  final String facebookUrl = "https://www.facebook.com/haideptraikhongtivet/";
  final String tiktokUrl = "https://www.tiktok.com/@justmikeandtroc/";

  Future<void> _launchUrl(String url) async {
    final String intentUrl = "googlechrome://navigate?url=$url";
    final Uri uri = Uri.parse(intentUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw "Không thể mở liên kết $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());

    return Scaffold(
      backgroundColor: themeController.isDarkMode
          ? themeController.color_darkMode
          : themeController.color_lightMode,
      appBar: AppBar(
        title: const Text("Thông Tin Liên Hệ"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 40,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Địa Chỉ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: themeController.isDarkMode
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Chùa Hà, Khu đô thị VCI, Vĩnh Yên, Vĩnh Phúc 280000",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: themeController.isDarkMode
                          ? Colors.grey.shade300
                          : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 30,
              color: themeController.isDarkMode
                  ? Colors.grey.shade600
                  : Colors.grey,
            ),
            Row(
              children: [
                const Icon(
                  Icons.phone,
                  size: 30,
                  color: Colors.orange,
                ),
                const SizedBox(width: 10),
                Text(
                  "Số Điện Thoại",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "0962734142",
              style: TextStyle(
                fontSize: 16,
                color: themeController.isDarkMode
                    ? Colors.grey.shade300
                    : Colors.black54,
              ),
            ),
            Divider(
              height: 30,
              color: themeController.isDarkMode
                  ? Colors.grey.shade600
                  : Colors.grey,
            ),
            Row(
              children: [
                const Icon(
                  Icons.email,
                  size: 30,
                  color: Colors.orange,
                ),
                const SizedBox(width: 10),
                Text(
                  "Email",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "lienhe@Zstore.shop",
              style: TextStyle(
                fontSize: 16,
                color: themeController.isDarkMode
                    ? Colors.grey.shade300
                    : Colors.black54,
              ),
            ),
            Divider(
              height: 30,
              color: themeController.isDarkMode
                  ? Colors.grey.shade600
                  : Colors.grey,
            ),
            Text(
              "Nếu có bất cứ thông tin gì thắc mắc hãy liên hệ với chúng tôi bằng các phương thức liên lạc trên. Cảm ơn đã lựa chọn Trung Tâm Nội Thất TH Luxury.",
              style: TextStyle(
                fontSize: 16,
                color:
                    themeController.isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Nút Facebook
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
            ),
          ],
        ),
      ),
    );
  }
}
