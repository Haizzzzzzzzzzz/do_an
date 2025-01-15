import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_grocery/controller/cart_controller.dart';
import 'package:my_grocery/controller/order_controller.dart';
import 'package:my_grocery/model/ad_banner.dart';
import 'package:my_grocery/model/cart_item.dart';
import 'package:my_grocery/model/category.dart';
import 'package:my_grocery/model/product.dart';
import 'package:my_grocery/model/tag.dart';
import 'package:my_grocery/model/user.dart';
import 'package:my_grocery/route/app_page.dart';
import 'package:my_grocery/route/app_route.dart';
import 'package:my_grocery/service/theme_service.dart';
import 'package:my_grocery/theme/app_theme.dart';

void main() async {
  log("message auth main");
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // Khởi tạo GetStorage
  Get.put(ThemeService()); // Thêm ThemeService vào GetX
  await Hive.initFlutter();
  Get.put(CartController());
  Get.put(OrderController());

  //register adapters
  Hive.registerAdapter(TagAdapter());
  Hive.registerAdapter(AdBannerAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(CartItemAdapter());

  configLoading();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Tạo instance của ThemeService
    // final themeService = ThemeService();
    return GetMaterialApp(
      getPages: AppPage.list,
      initialRoute: AppRoute.dashboard,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // themeMode: themeService.
      //     ? ThemeMode.dark
      //     : ThemeMode.light, // Sử dụng getter public
      builder: EasyLoading.init(),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..userInteractions = false
    ..maskType = EasyLoadingMaskType.black
    ..dismissOnTap = true;
}
