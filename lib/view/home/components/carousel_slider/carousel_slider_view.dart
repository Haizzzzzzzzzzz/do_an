import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_grocery/model/ad_banner.dart';
import 'package:my_grocery/view/home/components/carousel_slider/banner_card.dart';
import 'package:my_grocery/controller/theme_controller.dart';

class CarouselSliderView extends StatefulWidget {
  final List<AdBanner> bannerList;
  const CarouselSliderView({super.key, required this.bannerList});

  @override
  State<CarouselSliderView> createState() => _CarouselSliderViewState();
}

class _CarouselSliderViewState extends State<CarouselSliderView> {
  int _currentIndex = 0;
  late List<Widget> _bannerList;

  @override
  void initState() {
    _bannerList =
        widget.bannerList.map((e) => BannerCard(imageUrl: e.image)).toList();
    print("_bannerList $_bannerList");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeController =
        Get.find<ThemeController>(); // Lấy trạng thái Dark Mode

    return Container(
      color: themeController.isDarkMode
          ? themeController.color_darkMode
          : themeController.color_lightMode,
      padding: const EdgeInsets.all(10), // Padding cho phần nền
      child: Column(
        children: [
          CarouselSlider(
            items: _bannerList,
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.bannerList.map((e) {
              int index = widget.bannerList.indexOf(e);
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index
                      ? (themeController.isDarkMode
                          ? Colors.orange // Màu nổi bật Dark Mode
                          : Colors.blue) // Màu nổi bật Light Mode
                      : (themeController.isDarkMode
                          ? Colors.grey.shade600 // Màu nhạt Dark Mode
                          : Colors.grey.shade400), // Màu nhạt Light Mode
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
