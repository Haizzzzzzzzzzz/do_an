import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_grocery/controller/controllers.dart';
import 'package:my_grocery/controller/theme_controller.dart';
import 'package:my_grocery/extention/string_extention.dart';
import '../../../component/input_outline_button.dart';
import '../../../component/input_text_button.dart';
import 'sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  final themeController = Get.put(ThemeController());

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: themeController.isDarkMode
          ? themeController.color_darkMode
          : themeController.color_lightMode,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Text(
                  "Đăng Ký Tài Khoản,",
                  style: TextStyle(
                    color: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Hãy đăng ký để trải nghiệm tốt nhất",
                  style: TextStyle(
                    color: themeController.isDarkMode
                        ? Colors.grey.shade400
                        : Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(flex: 3),
                // Full Name
                _buildInputField(
                  title: 'Họ và tên',
                  controller: fullNameController,
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return "Không được để trống trường này";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                // Email
                _buildInputField(
                  title: 'Email',
                  controller: emailController,
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field can't be empty";
                    } else if (!value.isValidEmail) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                // Password
                _buildInputField(
                  title: 'Mật Khẩu',
                  controller: passwordController,
                  obsecureText: true,
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field can't be empty";
                    } else {
                      List<String> errors = [];
                      if (!value.isValidPasswordHasNumber) {
                        errors.add("Must contain 1 number");
                      }
                      if (!value.isValidPasswordHasCapitalLetter) {
                        errors.add("Must contain 1 capital letter");
                      }
                      if (!value.isValidPasswordHasLowerCaseLetter) {
                        errors.add("Must contain 1 simple letter");
                      }
                      if (!value.isValidPasswordHasSpecialCharacter) {
                        errors.add(
                            "Must contain 1 special character [! @ # \$ %]");
                      }
                      return errors.isNotEmpty ? errors.join("\n") : null;
                    }
                  },
                ),
                const SizedBox(height: 10),
                // Confirm Password
                _buildInputField(
                  title: 'Xác nhận mật khẩu',
                  controller: confirmController,
                  obsecureText: true,
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return "Không được để trống";
                    } else if (passwordController.text != value) {
                      return "Mật khẩu không khớp";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                const Spacer(),
                InputTextButton(
                  title: "Đăng Ký",
                  onClick: () {
                    if (_formKey.currentState!.validate()) {
                      authController.signUp(
                        fullName: fullNameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                      );
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
                const Spacer(flex: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Tôi đã có tài khoản, ",
                      style: TextStyle(
                        color: themeController.isDarkMode
                            ? themeController.color_lightMode
                            : themeController.color_darkMode,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Đăng Nhập",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String title,
    required TextEditingController controller,
    bool obsecureText = false,
    String? Function(String?)? validation,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obsecureText,
      validator: validation,
      decoration: InputDecoration(
        labelText: title,
        filled: true,
        fillColor:
            themeController.isDarkMode ? Colors.grey.shade800 : Colors.white,
        labelStyle: TextStyle(
          color: themeController.isDarkMode ? Colors.white : Colors.black,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      style: TextStyle(
        color: themeController.isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }
}
