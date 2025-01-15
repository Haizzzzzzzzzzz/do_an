import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_grocery/controller/theme_controller.dart';

class ChatBubble extends StatelessWidget {
  final bool isMine;
  final String? photoUrl;
  final String message;
  final double _iconSize = 24.0;

  const ChatBubble({
    required this.isMine,
    required this.photoUrl,
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final List<Widget> widgets = [];

    // User avatar
    widgets.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_iconSize),
          child: photoUrl == null
              ? const _DefaultPersonWidget()
              : CachedNetworkImage(
                  imageUrl: photoUrl!,
                  width: _iconSize,
                  height: _iconSize,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) =>
                      const _DefaultPersonWidget(),
                  placeholder: (context, url) => const _DefaultPersonWidget(),
                ),
        ),
      ),
    );

    // Message container
    widgets.add(
      Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: themeController.isDarkMode
              ? (isMine ? Colors.blueGrey.shade700 : Colors.grey.shade800)
              : (isMine ? Colors.blue.shade100 : Colors.grey.shade300),
        ),
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.all(8.0),
        child: message.isNotEmpty
            ? Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: themeController.isDarkMode
                          ? Colors.white
                          : Colors.black,
                    ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: isMine ? widgets.reversed.toList() : widgets,
      ),
    );
  }
}

class _DefaultPersonWidget extends StatelessWidget {
  const _DefaultPersonWidget();

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Icon(
      Icons.person,
      color: themeController.isDarkMode ? Colors.white : Colors.black,
      size: 12,
    );
  }
}
