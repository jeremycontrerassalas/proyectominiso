class Product {
  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String?,
        imageUrl: json['imageUrl'] ?? json['image_url'] as String?,
        createdAt: DateTime.parse(json['createdAt'] ?? json['created_at']),
      );
}
