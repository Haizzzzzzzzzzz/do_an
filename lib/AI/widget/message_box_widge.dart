import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_grocery/controller/theme_controller.dart';

class MessageBox extends StatefulWidget {
  final ValueChanged<String> onSendMessage;

  const MessageBox({required this.onSendMessage, super.key});

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  final TextEditingController _controller = TextEditingController();
  final themeController = Get.put(ThemeController());

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _controller,
        maxLines: 1,
        decoration: InputDecoration(
          filled: true,
          fillColor: themeController.isDarkMode
              ? Colors.grey.shade800 // Nền khi Dark Mode
              : Colors.grey.shade200, // Nền khi Light Mode
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(
              color: themeController.isDarkMode
                  ? Colors.grey.shade600 // Viền khi Dark Mode
                  : Colors.grey.shade400, // Viền khi Light Mode
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(
              color: themeController.isDarkMode
                  ? Colors.blue.shade300 // Viền khi Dark Mode
                  : Colors.blue.shade600, // Viền khi Light Mode
              width: 2.0,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
          hintText: "Hãy cho tôi biết bạn cần gì...",
          hintStyle: TextStyle(
            color: themeController.isDarkMode
                ? Colors.grey.shade300 // Màu chữ gợi ý khi Dark Mode
                : Colors.grey.shade600, // Màu chữ gợi ý khi Light Mode
          ),
          suffixIcon: IconButton(
            onPressed: () {
              if (_controller.text.trim().isNotEmpty) {
                widget.onSendMessage(_controller.text.trim());
                _controller.clear();
              }
            },
            icon: Icon(
              Icons.send,
              color: themeController.isDarkMode
                  ? Colors.blue.shade300 // Icon khi Dark Mode
                  : Colors.blue.shade600, // Icon khi Light Mode
            ),
          ),
        ),
        style: TextStyle(
          color: themeController.isDarkMode
              ? Colors.white // Màu chữ khi Dark Mode
              : Colors.black, // Màu chữ khi Light Mode
        ),
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            widget.onSendMessage(value.trim());
            _controller.clear();
          }
        },
      ),
    );
  }
}
