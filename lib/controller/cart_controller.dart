import 'dart:convert';

import 'package:get/get.dart';
import 'package:my_grocery/controller/controllers.dart';
import 'package:my_grocery/model/cart_item.dart';
import 'package:my_grocery/service/local_service/local_cart_service.dart';
import 'package:my_grocery/service/remote_service/remote_cart_service.dart';

class CartController extends GetxController {
  static CartController instance = Get.find();

  RxList<CartItem> cartItemList = List<CartItem>.empty(growable: true)
      .obs; // Danh sách các sản phẩm trong giỏ hàng
  var selectedCartItems = <CartItem>[].obs; // Danh sách sản phẩm được chọn

  final LocalCartService _localCartService =
      LocalCartService(); // Dịch vụ cục bộ
  RxBool isCartLoading = false.obs; // Trạng thái tải giỏ hàng
  final RemoteCartService _remoteCartService = RemoteCartService();
  // Thuộc tính lưu trữ trạng thái checkbox cart
  final selectedItems = <CartItem>[].obs;

  bool isSelected(CartItem item) => selectedItems.contains(item);

  @override
  void onInit() async {
    super.onInit();
    await _localCartService.init(); // Khởi tạo dịch vụ cục bộ
    String? userEmail = authController
        .user.value?.email; // Thay bằng cách lấy email người dùng thực tế
    getCartItems(userEmail); // Truyền email vào phương thức
  }

  // Hàm lấy danh sách sản phẩm trong giỏ hàng
  Future<void> getCartItems(String? email) async {
    try {
      isCartLoading(true);
      // Kiểm tra dữ liệu trong local storage
      if (_localCartService.getCartItems().isNotEmpty) {
        cartItemList.assignAll(_localCartService.getCartItems());
      }
      // Lấy dữ liệu từ API nếu cần
      var result = await RemoteCartService().getCart(email); // Truyền email vào
      if (result != null) {
        cartItemList.assignAll(cartItemListFromJson(
            result.body)); // Cập nhật danh sách sản phẩm từ API
        _localCartService.assignAllCartItems(
            // Lưu lại vào local storage
            cartItems: cartItemListFromJson(result.body));
      }
    } finally {
      isCartLoading(false);
    }
  }

  // Hàm riêng để lấy ID của giỏ hàng từ API trả về
  Future<int?> getCartId(String? email) async {
    var response = await RemoteCartService()
        .getCart(email); // Gọi hàm getCart để lấy dữ liệu giỏ hàng

    if (response.statusCode == 200) {
      // Giải mã phản hồi từ response.body thành JSON
      var cartData = jsonDecode(response.body);

      if (cartData != null &&
          cartData['data'] != null &&
          cartData['data'].isNotEmpty) {
        int cartId = cartData['data'][0]['id']; // Lấy ID giỏ hàng từ dữ liệu
        print("Cart ID: $cartId");
        return cartId; // Trả về ID của giỏ hàng
      } else {
        print("No cart found");
        return null;
      }
    } else {
      print("Failed to fetch cart data");
      return null;
    }
  }

// Hàm tải lại giỏ hàng khi kéo trượt từ trên xuống
  Future<void> loadCartItems() async {
    String? userEmail = authController.user.value?.email
        .toString(); // Lấy email người dùng hiện tại
    await getCartItems(userEmail); // Gọi hàm lấy giỏ hàng
  }

  // Hàm thêm sản phẩm vào giỏ hàng
  void addToCart(CartItem cartItem, int? cartId) async {
    try {
      isCartLoading(true);

      // Kiểm tra xem sản phẩm với cùng ID sản phẩm và tag đã tồn tại chưa
      int existingIndex = cartItemList.indexWhere((item) =>
          item.product.id == cartItem.product.id &&
          item.tag?.id == cartItem.tag?.id);

      if (existingIndex != -1) {
        // Nếu sản phẩm đã tồn tại, tăng số lượng
        CartItem existingItem = cartItemList[existingIndex];
        int newQuantity = existingItem.quantity + cartItem.quantity;

        // Cập nhật số lượng sản phẩm trong local storage
        await _localCartService.updateCartItem(existingItem, newQuantity);

        // Cập nhật số lượng sản phẩm trên server
        await RemoteCartService()
            .updateCartItem(cartItemList[existingIndex].id, newQuantity);

        // Cập nhật số lượng trong danh sách hiển thị
        cartItemList[existingIndex].quantity = newQuantity;
      } else {
        // Nếu sản phẩm chưa tồn tại, thêm mới vào local storage và server
        _localCartService.addCartItem(cartItem);
        cartItemList.add(cartItem);

        // Gửi dữ liệu lên server
        await RemoteCartService().addToCart(cartId, cartItem.product.id,
            cartItem.quantity, cartItem.price, cartItem.tag?.id);
      }

      // Cập nhật danh sách giỏ hàng nếu sử dụng GetX
      cartItemList.refresh();
    } catch (e) {
      print("Error adding item to cart: $e");
    } finally {
      isCartLoading(false);
    }
  }

  // Hàm cập nhật số lượng sản phẩm trong giỏ hàng
  void updateCartItemQuantity(CartItem cartItem, int quantity) async {
    try {
      isCartLoading(true);
      _localCartService.updateCartItem(cartItem, quantity);
      int index = cartItemList.indexWhere((item) => item.id == cartItem.id);
      if (index != -1) {
        cartItemList[index].quantity = quantity;
      }
      // Gửi dữ liệu cập nhật lên server
      await RemoteCartService().updateCartItem(cartItem.id, quantity);
    } finally {
      isCartLoading(false);
    }
  }

  // Hàm xóa sản phẩm khỏi giỏ hàng
  void removeFromCart(CartItem cartItem) async {
    try {
      isCartLoading(true);
      _localCartService.removeCartItem(cartItem.id);
      cartItemList.removeWhere((item) => item.id == cartItem.id);
      // Xóa trên server
      await RemoteCartService().removeFromCart(cartItem.id);
    } finally {
      isCartLoading(false);
    }
  }

  // Hàm xóa tất cả sản phẩm có trạng thái giống nhau
  Future<void> clearCartItemsByStatus(
      String status, List<int> selectedItemIds) async {
    try {
      isCartLoading(true);

      // Gọi API để lấy tất cả các sản phẩm có status giống nhau
      var response = await _remoteCartService.getCartItemsByStatus(status);
      var cartData = jsonDecode(response.body);

      if (cartData != null && cartData['data'] != null) {
        var cartItems = cartData['data'][0]['attributes']['cart_items']['data'];

        // Lặp qua danh sách và chỉ xóa các sản phẩm nằm trong `selectedItemIds`
        for (var cartItem in cartItems) {
          var cartItemId = cartItem['id']; // Lấy ID của sản phẩm trong giỏ hàng

          // Chỉ xóa nếu sản phẩm nằm trong danh sách `selectedItemIds`
          if (selectedItemIds.contains(cartItemId)) {
            print("Deleting cartItemId: $cartItemId");
            await _remoteCartService.deleteCartItem(cartItemId);
          }
        }

        print("Selected cart items with status $status have been deleted.");
      }
    } catch (e) {
      print("Error clearing cart items by status: $e");
    } finally {
      isCartLoading(false);
    }
  }

  void toggleSelection(CartItem cartItem) {
    if (isSelected(cartItem)) {
      selectedItems.remove(cartItem);
      print("Không lựa chọn");
      if (selectedCartItems.contains(cartItem)) {
        selectedCartItems.remove(cartItem);
      }
    } else {
      selectedItems.add(cartItem);
      print("Đã lựa chọn");
      selectedCartItems.add(cartItem);
    }
    print("Selected Items: ${selectedCartItems.map((e) => e.id).toList()}");
  }

  ///////////////////////////////////////
  ///
  ///
  Future<void> removeSelectedItems(List<CartItem> selectedItemsToRemove) async {
    try {
      isCartLoading(true);

      for (final item in selectedItemsToRemove) {
        await _localCartService.removeCartItem(item.id);
        await RemoteCartService().removeFromCart(item.id);
        cartItemList.remove(item);
      }

      selectedCartItems.clear();
      update();
    } catch (e) {
      print("Error while removing selected items: $e");
    } finally {
      isCartLoading(false);
    }
  }

  void toggleSelectAll() {
    // Lặp qua danh sách và đặt trạng thái selected
    for (var item in cartItemList) {
      if (isSelected(item)) {
        selectedItems.remove(item); // Xóa khỏi danh sách đã chọn
        print("Không lựa chọn");
        if (selectedCartItems.contains(item)) {
          selectedCartItems.remove(item);
        }
      } else {
        selectedItems.add(item); // Thêm vào danh sách đã chọn
        print("Đã lựa chọn");
        selectedCartItems.add(item);
      }
    }
    update(); // Cập nhật trạng thái UI
  }

  bool areAllSelected() {
    // Kiểm tra xem tất cả các mục trong giỏ hàng có được chọn không
    update();
    return cartItemList.isNotEmpty &&
        cartItemList.every((item) => isSelected(item));
  }
}
