import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_grocery/controller/controllers.dart';
import 'package:my_grocery/controller/theme_controller.dart';
import 'package:my_grocery/extention/string_extention.dart';

import '../../../component/input_outline_button.dart';
import '../../../component/input_text_button.dart';
import '../../../component/input_text_field.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final themeController = Get.put(ThemeController());

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: themeController.isDarkMode
          ? themeController.color_darkMode
          : themeController.color_lightMode,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20), // Khoảng cách phía trên
                  themeController.isDarkMode
                      ? Image.asset(
                          'assets/logo_darkmode.png',
                          fit: BoxFit.contain,
                        )
                      : Image.asset(
                          'assets/logo_lightmode.png',
                          fit: BoxFit.contain,
                        ),
                  TextFormField(
                    controller: emailController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "email không được để trống";
                      } else if (!value.isValidEmail) {
                        return "Vui lòng nhập email hợp lệ";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: themeController.isDarkMode
                          ? Colors.grey.shade800
                          : Colors.white,
                      labelStyle: TextStyle(
                        color: themeController.isDarkMode
                            ? Colors.white
                            : Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    style: TextStyle(
                      color: themeController.isDarkMode
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Password Field
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "This field can't be empty";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      filled: true,
                      fillColor: themeController.isDarkMode
                          ? Colors.grey.shade800
                          : Colors.white,
                      labelStyle: TextStyle(
                        color: themeController.isDarkMode
                            ? Colors.white
                            : Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    style: TextStyle(
                      color: themeController.isDarkMode
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Text(
                          "Quên mật khẩu",
                          style: TextStyle(
                            fontSize: 12,
                            color: themeController.isDarkMode
                                ? Colors.grey.shade300
                                : Colors.grey,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20), // Khoảng cách phía trên
                  InputTextButton(
                    title: "Đăng Nhập",
                    onClick: () {
                      if (_formKey.currentState!.validate()) {
                        authController.signIn(
                            email: emailController.text,
                            password: passwordController.text);
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  InputOutlineButton(
                    title: "Trở lại",
                    onClick: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(height: 20), // Khoảng cách phía trên
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Bạn là một người dùng mới, ",
                        style: TextStyle(
                          color: themeController.isDarkMode
                              ? Colors.grey.shade300
                              : Colors.black,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()));
                        },
                        child: Text(
                          "Đăng ký",
                          style: TextStyle(
                            color: themeController.isDarkMode
                                ? Colors.blue.shade300
                                : Colors.blue,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
