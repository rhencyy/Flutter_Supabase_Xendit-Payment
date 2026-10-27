import 'package:flutter/material.dart';

import '../services/cart_service.dart';
import '../services/payment_service.dart';
import '../utils/format.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static const _brown = Color(0xFF5C3A21);
  final _cart = CartService.instance;
  final _payment = PaymentService();
  bool _paying = false;

  void _snack(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> _checkout() async {
    setState(() => _paying = true);
    try {
      final status = await _payment.pay(
        context,
        productName: _cart.summary,
        amount: _cart.total,
      );
      if (!mounted) return;
      if (status == 'PAID') {
        _cart.clear();
        _snack('Payment successful! Thank you for your order.');
      } else {
        _snack('Payment status: ${status ?? 'unknown'}. Check the Orders tab.');
      }
    } catch (e) {
      if (mounted) _snack('Could not start payment: $e');
    } finally {
      if (mounted) setState(() => _paying = false);
    }
  }

  Widget _thumb(String? url) {
    final fallback = Container(
      width: 64,
      height: 64,
      color: const Color(0xFFF1E4D6),
      child: const Icon(Icons.checkroom, color: Color(0xFFA68A74)),
    );
    if (url == null || url.isEmpty) return fallback;
    return Image.network(url,
        width: 64, height: 64, fit: BoxFit.cover, errorBuilder: (_, __, ___) => fallback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: _brown,
        foregroundColor: Colors.white,
      ),
      body: ListenableBuilder(
        listenable: _cart,
        builder: (context, _) {
          if (_cart.isEmpty) {
            return const Center(
              child: Text(
                'Your cart is empty.\nChoose products from the Shop tab.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          final items = _cart.items;
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final item = items[i];
                    return Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: _thumb(item.product.imageUrl),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text(peso(item.product.price),
                                      style: const TextStyle(color: _brown)),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => _cart.decrease(item.product),
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                            Text('${item.qty}',
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                            IconButton(
                              onPressed: () => _cart.add(item.product),
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                            IconButton(
                              onPressed: () => _cart.remove(item.product),
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black12)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total', style: TextStyle(fontSize: 16)),
                        Text(peso(_cart.total),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, color: _brown)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _paying ? null : _checkout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _brown,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: _paying
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : const Text('Checkout with Xendit',
                                style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}