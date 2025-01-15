import 'package:flutter/material.dart';
import 'package:my_grocery/view/product/components/product_card.dart';

import '../../../model/product.dart';

class ProductGridHome extends StatelessWidget {
  final List<Product> products;
  const ProductGridHome({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true, // Giới hạn chiều cao GridView
      physics:
          const NeverScrollableScrollPhysics(), // Vô hiệu hóa cuộn riêng của GridView
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (context, index) => ProductCard(product: products[index]),
    );
  }
}
