import 'dart:convert';

import 'package:hive/hive.dart';

import 'tag.dart';

part 'product.g.dart';

List<Product> popularProductListFromJson(String val) => List<Product>.from(
    json.decode(val)['data'].map((val) => Product.popularProductFromJson(val)));

List<Product> productListFromJson(String val) => List<Product>.from(
    json.decode(val)['data'].map((val) => Product.productFromJson(val)));

@HiveType(typeId: 3)
class Product {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final List<String> images;
  @HiveField(4)
  final List<Tag> tags;

  Product(
      {required this.id,
      required this.name,
      required this.description,
      required this.images,
      required this.tags});

  factory Product.popularProductFromJson(Map<String, dynamic> data) => Product(
      id: data['attributes']['product']['data']['id'],
      name: data['attributes']['product']['data']['attributes']['name'],
      description: data['attributes']['product']['data']['attributes']
          ['description'],
      images: List<String>.from(data['attributes']['product']['data']
              ['attributes']['images']['data']
          .map((image) => image['attributes']['url'])),
      tags: List<Tag>.from(data['attributes']['product']['data']['attributes']
              ['tags']['data']
          .map((val) => Tag.fromJson(val))));

  factory Product.productFromJson(Map<String, dynamic> data) => Product(
      id: data['id'],
      name: data['attributes']['name'],
      description: data['attributes']['description'],
      images: List<String>.from(data['attributes']['images']['data']
          .map((image) => image['attributes']['url'])),
      tags: List<Tag>.from(
          data['attributes']['tags']['data'].map((val) => Tag.fromJson(val))));

  // Chuyển JSON thành đối tượng Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      tags: (json['tags'] as List)
          .map((tag) => Tag.fromJson(tag))
          .toList(), // Chuyển tag JSON thành đối tượng Tag
    );
  }

  // Phương thức toJson để chuyển đối tượng Product thành JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'images': images,
        'tags': tags.map((tag) => tag.toJson()).toList(),
      };

  @override
  String toStringProduct() {
    return toJson().toString(); // Hiển thị dưới dạng JSON
  }
}
