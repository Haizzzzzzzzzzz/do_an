import 'package:hive/hive.dart';
import '../../model/cart_item.dart';

class LocalCartService {
  late Box<CartItem> _cartBox;

  // Khởi tạo hộp lưu trữ cho giỏ hàng
  Future<void> init() async {
    _cartBox = await Hive.openBox<CartItem>('cartItems');
  }

  // Gán toàn bộ sản phẩm vào giỏ hàng, xóa dữ liệu cũ trước khi thêm mới
  Future<void> assignAllCartItems({required List<CartItem> cartItems}) async {
    await _cartBox.clear();
    await _cartBox.addAll(cartItems);
  }

  // Thêm một sản phẩm mới vào giỏ hàng
  Future<void> addCartItem(CartItem cartItem) async {
    await _cartBox.add(cartItem);
  }

  // Cập nhật số lượng cho sản phẩm trong giỏ hàng
  Future<void> updateCartItem(CartItem cartItem, int quantity) async {
    int index =
        _cartBox.values.toList().indexWhere((item) => item.id == cartItem.id);
    if (index != -1) {
      cartItem.quantity = quantity;
      await _cartBox.putAt(
          index, cartItem); // Cập nhật lại giỏ hàng tại vị trí index
    }
  }

  // Xóa sản phẩm khỏi giỏ hàng
  Future<void> removeCartItem(int cartItemId) async {
    int index =
        _cartBox.values.toList().indexWhere((item) => item.id == cartItemId);
    if (index != -1) {
      await _cartBox.deleteAt(index);
    }
  }

  // Lấy tất cả các sản phẩm trong giỏ hàng
  List<CartItem> getCartItems() => _cartBox.values.toList();
}
