// class Tag {
//   final int id;
//   final String title;
//   final double price;

//   Tag({required this.id, required this.title, required this.price});

//   factory Tag.fromJson(Map<String, dynamic> data) => Tag(
//       id: data['id'],
//       title: data['attributes']['title'],
//       price: data['attributes']['price'].toDouble());

//   // Phương thức toJson để chuyển đối tượng Tag thành JSON
//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'title': title,
//         'price': price,
//       };
// }

import 'package:hive/hive.dart';

part 'tag.g.dart';

@HiveType(typeId: 6) // Đảm bảo 'typeId' là duy nhất cho mỗi model
class Tag {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double price;

  Tag({required this.id, required this.title, required this.price});

  factory Tag.fromJson(Map<String, dynamic>? data) {
    if (data == null) {
      throw Exception("Invalid JSON: Tag data is null");
    }

    final attributes = data['attributes'] ?? {};
    return Tag(
      id: data['id'] ?? 0, // Đặt giá trị mặc định nếu 'id' bị null
      title:
          attributes['title'] ?? "Unknown", // Giá trị mặc định nếu 'title' null
      price: (attributes['price'] != null ? attributes['price'] as num : 0)
          .toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
      };

  @override
  String toStringTag() {
    return toJson().toString(); // Hiển thị dưới dạng JSON
  }
}
