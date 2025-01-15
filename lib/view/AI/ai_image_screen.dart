import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:my_grocery/controller/cart_controller.dart';
import 'package:my_grocery/controller/controllers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_grocery/AI/create_image/home_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class AiImageScreen extends ConsumerStatefulWidget {
  const AiImageScreen({super.key});

  @override
  _AiImageScreenState createState() => _AiImageScreenState();
}

class _AiImageScreenState extends ConsumerState<AiImageScreen> {
  final TextEditingController textController = TextEditingController();

  // List of device options
  final List<String> deviceOptions = [
    'iPhone 16',
    'Samsung Galaxy S23 Ultra',
    'Google Pixel 9',
    'OnePlus 9',
    'Xiaomi Mi 11'
  ];

  String selectedDevice = 'iPhone 16';

  Future<void> saveImageFromBytes(Uint8List imageBytes) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/image.png';

      final file = File(filePath);
      await file.writeAsBytes(imageBytes);

      final result = await ImageGallerySaver.saveFile(file.path);
      print("Image saved result: $result");
    } catch (e) {
      print("Error saving image: $e");
    }
  }

  void updateDeviceOptions(List<String> newOptions) {
    setState(() {
      deviceOptions.clear();
      deviceOptions.addAll(newOptions);

      // Kiểm tra nếu `selectedDevice` không nằm trong danh sách mới
      if (!deviceOptions.contains(selectedDevice)) {
        selectedDevice = deviceOptions.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final fWatch = ref.watch(homeProvider);
    final fRead = ref.read(homeProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xff212121),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      'Tạo phong cách với Z Store',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.openSans().fontFamily,
                      ),
                    ),
                    const SizedBox(height: 20),
                    DropdownButton<String>(
                      value: selectedDevice,
                      dropdownColor: const Color(0xff424242),
                      items: deviceOptions.map((String device) {
                        return DropdownMenuItem<String>(
                          value: device,
                          child: Text(
                            device,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedDevice = newValue;
                          });
                        }
                      },
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 30),
                    fWatch.isLoading && fWatch.imageData != null
                        ? Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height: 320,
                                width: 320,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Image.memory(fWatch.imageData!),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  if (fWatch.imageData != null) {
                                    await fRead.saveImageAndCreateOrder(
                                      context,
                                      DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString(),
                                      selectedDevice,
                                      authController.user.value?.email ??
                                          "Guest",
                                      fWatch.imageData!,
                                    );
                                  } else {
                                    debugPrint("Chưa có ảnh để lưu.");
                                  }
                                },
                                icon: const Icon(
                                  Icons.phone_android_outlined,
                                  color: Colors.orange,
                                ),
                                label: const Text(
                                  "Đặt làm ốp điện thoại",
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  textStyle: const TextStyle(fontSize: 16),
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  if (fWatch.imageData != null) {
                                    saveImageFromBytes(fWatch.imageData!);
                                  }
                                },
                                icon: const Icon(
                                  Icons.download,
                                  color: Colors.orange,
                                ),
                                label: const Text(
                                  "Tải hình ảnh về",
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  textStyle: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          )
                        : Container(
                            alignment: Alignment.center,
                            height: 320,
                            width: 320,
                            decoration: BoxDecoration(
                              color: const Color(0xff424242),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  size: 100,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Chưa có hình ảnh nào được tạo.',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    fontFamily:
                                        GoogleFonts.openSans().fontFamily,
                                  ),
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(height: 50),
                    buildInputArea(context, fRead, fWatch),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputArea(
      BuildContext context, HomeProvider fRead, HomeProvider fWatch) {
    return Column(
      children: [
        Container(
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xff424242),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: TextField(
            controller: textController,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w400,
              fontFamily: GoogleFonts.openSans().fontFamily,
            ),
            cursorColor: Colors.white,
            maxLines: 5,
            decoration: InputDecoration(
              hintText:
                  'Nhập nội dung bạn muốn tạo ảnh (PS: Hãy nhập bằng tiếng anh nhé <3)',
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: GoogleFonts.openSans().fontFamily,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(12.0),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                fRead.textToImage(textController.text, context);
                fRead.searchingChange(true);
              },
              child: Container(
                alignment: Alignment.center,
                height: 60,
                width: 160,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.deepPurpleAccent, Colors.purple],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
                child: fWatch.isSearching
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Tạo ảnh',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.openSans().fontFamily,
                        ),
                      ),
              ),
            ),
            GestureDetector(
              onTap: () {
                fRead.loadingChange(false);
                textController.clear();
              },
              child: Container(
                alignment: Alignment.center,
                height: 60,
                width: 160,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.pink, Colors.red],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
                child: Text(
                  'Xóa Bỏ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.openSans().fontFamily,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
