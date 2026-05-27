import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  const ProductTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.imageUrl;
    final imageWidget = imageUrl == null
        ? Container(color: Colors.grey[300], child: const Icon(Icons.image, size: 48))
        : imageUrl.startsWith('data:image/')
            ? Builder(
                builder: (context) {
                  final commaIndex = imageUrl.indexOf(',');
                  if (commaIndex == -1) {
                    return Container(color: Colors.grey[300], child: const Icon(Icons.broken_image, size: 48));
                  }
                  final base64Part = imageUrl.substring(commaIndex + 1);
                  try {
                    return Image.memory(base64Decode(base64Part), fit: BoxFit.cover);
                  } catch (_) {
                    return Container(color: Colors.grey[300], child: const Icon(Icons.broken_image, size: 48));
                  }
                },
              )
            : Image.network(product.imageUrl!, fit: BoxFit.cover);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: imageWidget,
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
