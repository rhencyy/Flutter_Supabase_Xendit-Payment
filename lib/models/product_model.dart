class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String category; // 'Hoodies', 'Shirts', 'Pants', 'Caps'
  final List<String> sizes;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.sizes = const ['S', 'M', 'L', 'XL'],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] ?? '',
      category: json['category'] ?? 'Shirts',
      sizes: List<String>.from(json['sizes'] ?? ['S', 'M', 'L', 'XL']),
    );
  }
}
