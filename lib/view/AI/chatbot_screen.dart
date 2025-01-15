import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_grocery/AI/widget/chat_bubble_widget.dart';
import 'package:my_grocery/AI/widget/message_box_widge.dart';
import 'package:my_grocery/AI/worker/genai_worker.dart';
import 'package:my_grocery/controller/theme_controller.dart';
import 'package:my_grocery/view/AI/ai_image_screen.dart';

class ChatBotScreen extends StatefulWidget {
  final List<String> selectedTitles; // Nhận danh sách sản phẩm từ CartScreen

  const ChatBotScreen({super.key, required this.selectedTitles});

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final GenAIWorker genAIWorker = GenAIWorker();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectedTitles.isNotEmpty) {
      _sendProductAnalysisRequest();
    }
    genAIWorker.stream.listen((data) {
      setState(() {
        isLoading = false; // Tắt hiệu ứng chờ khi nhận được phản hồi
      });
    });
  }

  void _sendProductAnalysisRequest() {
    setState(() {
      isLoading = true;
    });
    final productNames = widget.selectedTitles.join(', ');
    genAIWorker
        .sendToGemini("Phân tích và so sánh các sản phẩm này: $productNames");
  }

  void _sendMessage(String message) {
    setState(() {
      isLoading = true; // Bắt đầu hiệu ứng chờ khi gửi tin nhắn
    });
    genAIWorker.sendToGemini(message);
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    return Scaffold(
      backgroundColor: themeController.isDarkMode
          ? themeController.color_darkMode
          : themeController.color_lightMode,
      appBar: AppBar(
        title: const Text(
          "Chatbot AI Z store",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AiImageScreen()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatContent>>(
              stream: genAIWorker.stream,
              builder: (context, snapshot) {
                final List<ChatContent> data = snapshot.data ?? [];
                if (snapshot.hasData && data.isNotEmpty) {
                  return ListView(
                    children: data.map((e) {
                      final bool isMine = e.sender == Sender.user;
                      return ChatBubble(
                          isMine: isMine, photoUrl: null, message: e.message);
                    }).toList(),
                  );
                } else if (isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Center(
                    child: Text(
                      "Chưa có tin nhắn nào",
                      style: TextStyle(
                        color: themeController.isDarkMode
                            ? themeController.color_lightMode
                            : themeController.color_darkMode,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          MessageBox(
            onSendMessage: _sendMessage,
          ),
        ],
      ),
    );
  }
}
