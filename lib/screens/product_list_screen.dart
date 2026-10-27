import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';
import '../models/product_model.dart';
import '../services/cart_service.dart';
import '../services/payment_service.dart';
import '../utils/format.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  static const _brown = Color(0xFF5C3A21);
  final _payment = PaymentService();
  late Future<List<Product>> _future;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Product>> _load() async {
    final rows = await Supabase.instance.client.from('products').select();
    return (rows as List)
        .map((r) => Product.fromMap(Map<String, dynamic>.from(r as Map)))
        .toList();
  }

  Future<void> _refresh() async {
    final f = _load();
    setState(() => _future = f);
    await f;
  }

  void _snack(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> _buyNow(Product p) async {
    try {
      final status = await _payment.pay(context, productName: p.name, amount: p.price);
      if (!mounted || status == null) return;
      _snack('Payment status: $status');
    } catch (e) {
      if (!mounted) return;
      _snack('Could not start payment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConfig.shopName),
        backgroundColor: _brown,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: TextField(
              onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Search clothes',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text('Could not load products:\n${snap.error}',
                          textAlign: TextAlign.center),
                    ),
                  );
                }
                final products = (snap.data ?? [])
                    .where((p) => p.name.toLowerCase().contains(_query))
                    .toList();
                if (products.isEmpty) {
                  return const Center(child: Text('No products found'));
                }
                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 230,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: products.length,
                    itemBuilder: (_, i) {
                      final p = products[i];
                      return _ProductCard(
                        product: p,
                        onAdd: () {
                          CartService.instance.add(p);
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          _snack('${p.name} added to cart');
                        },
                        onBuy: () => _buyNow(p),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;
  final VoidCallback onBuy;

  const _ProductCard({
    required this.product,
    required this.onAdd,
    required this.onBuy,
  });

  Widget _placeholder() => Container(
        color: const Color(0xFFF1E4D6),
        child: const Center(
          child: Icon(Icons.checkroom, size: 48, color: Color(0xFFA68A74)),
        ),
      );

  Widget _image() {
    final url = product.imageUrl;
    if (url == null || url.isEmpty) return _placeholder();
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (_, __, ___) => _placeholder(),
      loadingBuilder: (_, child, progress) => progress == null ? child : _placeholder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _image()),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
            child: Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 2, 10, 6),
            child: Text(peso(product.price),
                style: const TextStyle(color: Color(0xFF5C3A21), fontWeight: FontWeight.w600)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 4, 8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onBuy,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5C3A21),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text('Buy Now'),
                  ),
                ),
                IconButton(
                  onPressed: onAdd,
                  tooltip: 'Add to cart',
                  icon: const Icon(Icons.add_shopping_cart, color: Color(0xFF5C3A21)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}