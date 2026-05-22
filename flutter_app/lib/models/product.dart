class Product {
  final String id;
  final String title;
  final String? code;
  final String? tags;
  final String? description;
  final String? imageUrl;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.title,
    this.code,
    this.tags,
    this.description,
    this.imageUrl,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        title: json['title'] as String,
      code: json['code'] as String? ?? json['product_code'] as String?,
      tags: json['tags'] as String?,
        description: json['description'] as String?,
        imageUrl: json['imageUrl'] ?? json['image_url'] as String?,
        createdAt: DateTime.parse(json['createdAt'] ?? json['created_at']),
      );
}
