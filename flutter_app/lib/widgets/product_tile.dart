import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  const ProductTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: product.imageUrl != null
          ? Image.network(product.imageUrl!, width: 56, height: 56, fit: BoxFit.cover)
          : Container(width: 56, height: 56, color: Colors.grey[300]),
      title: Text(product.title),
      subtitle: Text(product.description ?? ''),
    );
  }
}
