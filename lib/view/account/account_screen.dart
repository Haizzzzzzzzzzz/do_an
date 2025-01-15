import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_grocery/controller/controllers.dart';
import 'package:my_grocery/controller/theme_controller.dart';
import 'package:my_grocery/view/account/setting_screen.dart';
import 'package:my_grocery/view/order/my_order_screen.dart';
import 'package:my_grocery/view/policy/about_us_screen.dart';
import 'package:my_grocery/view/policy/contact_screen.dart';
import 'package:my_grocery/view/policy/shipping_warranty.dart';

import 'auth/sign_in_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Container(
      color: themeController.isDarkMode
          ? themeController.color_darkMode
          : themeController.color_lightMode,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 20),
            Obx(
              () => Row(
                children: [
                  CircleAvatar(
                    backgroundColor: themeController.isDarkMode
                        ? Colors.grey.shade800
                        : Colors.grey,
                    radius: 36,
                    child: const CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage("assets/user_image.png"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      Text(
                        authController.user.value?.fullName ??
                            "Hãy đăng nhập tài khoản.",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: themeController.isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 50),
            buildAccountCard(
              title: "Đơn Hàng",
              onClick: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyOrderScreen()));
              },
              themeController: themeController,
            ),
            buildAccountCard(
              title: "Cài Đặt",
              onClick: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingScreen()));
              },
              themeController: themeController,
            ),
            buildAccountCard(
              title: "Liên Hệ",
              onClick: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ContactScreen()));
              },
              themeController: themeController,
            ),
            buildAccountCard(
              title: "Giới thiệu",
              onClick: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AboutUsScreen()));
              },
              themeController: themeController,
            ),
            buildAccountCard(
              title: "Vận Chuyển Và Bảo Hành",
              onClick: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ShippingWarranty()));
              },
              themeController: themeController,
            ),
            Obx(
              () => buildAccountCard(
                title: authController.user.value == null
                    ? "Đăng Nhập"
                    : "Đăng Xuất",
                onClick: () {
                  if (authController.user.value != null) {
                    authController.signOut();
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInScreen()));
                  }
                },
                themeController: themeController,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAccountCard({
    required String title,
    required Function() onClick,
    required ThemeController themeController,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GestureDetector(
        onTap: () {
          onClick();
        },
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: themeController.isDarkMode
                ? Colors.grey.shade800
                : Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: themeController.isDarkMode
                    ? Colors.black.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.4),
                spreadRadius: 0.1,
                blurRadius: 7,
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color:
                      themeController.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_right_outlined,
                color: themeController.isDarkMode ? Colors.white : Colors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }
}
