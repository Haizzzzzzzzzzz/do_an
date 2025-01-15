import 'dart:convert';
import 'package:hive/hive.dart';
import 'product.dart';
import 'tag.dart';

part 'cart_item.g.dart';

List<CartItem> cartItemListFromJson(String val) {
  var decodedJson = json.decode(val);
  print("decodedJson: $decodedJson");

  if (decodedJson['data'] != null) {
    return List<CartItem>.from(
      decodedJson['data'].expand((val) =>
          CartItem.cartItemsFromJson(val['attributes']['cart_items']['data'])),
    );
  } else {
    return [];
  }
}

@HiveType(typeId: 5)
class CartItem {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final Product product;

  @HiveField(2)
  int quantity;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final Tag? tag;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.price,
    required this.tag,
  });

  static List<CartItem> cartItemsFromJson(List<dynamic> cartItems) {
    return List<CartItem>.from(
      cartItems.map((item) {
        final productData = item['attributes']['product']['data'];
        final tagsData = item['attributes']['tag']['data'];

        return CartItem(
          id: item['id'],
          product: Product.productFromJson(productData ?? {}),
          quantity: item['attributes']['quantity'],
          price: (item['attributes']['price'] as num).toDouble(),
          tag: tagsData != null && tagsData.isNotEmpty
              ? Tag.fromJson(tagsData)
              : null,
        );
      }),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'product': product.toJson(),
        'quantity': quantity,
        'price': price,
        'tag': tag?.toJson(),
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
