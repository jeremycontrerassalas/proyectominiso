import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  const ProductTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: product.imageUrl != null
                ? Image.network(product.imageUrl!, fit: BoxFit.cover)
                : Container(color: Colors.grey[300], child: const Icon(Icons.image, size: 48)),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text('Código: ${product.code ?? '-'}'),
                const SizedBox(height: 4),
                Text('Etiquetas: ${product.tags ?? '-'}'),
                if ((product.description ?? '').isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(product.description!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
