class Product {
  final String id;
  final String name;
  final double price;
  final String? description;
  final String? imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.imageUrl,
  });

  factory Product.fromMap(Map<String, dynamic> m) {
    return Product(
      id: m['id'].toString(),
      name: (m['name'] ?? '').toString(),
      price: double.tryParse(m['price'].toString()) ?? 0,
      description: m['description']?.toString(),
      imageUrl: m['image_url']?.toString(),
    );
  }
}