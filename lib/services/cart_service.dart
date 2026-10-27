import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class CartItem {
  final Product product;
  int qty;
  CartItem({required this.product, this.qty = 1});
}

class CartService extends ChangeNotifier {
  static final CartService instance = CartService._internal();
  CartService._internal();

  final List<CartItem> _items = [];
  List<CartItem> get items => _items;

  bool get isEmpty => _items.isEmpty;

  int get count => _items.fold(0, (sum, item) => sum + item.qty);

  double get total => _items.fold(0, (sum, item) => sum + (item.product.price * item.qty));

  String get summary => _items.map((i) => '${i.qty}x ${i.product.name}').join(', ');

  void add(Product product) {
    final index = _items.indexWhere((i) => i.product.id == product.id);
    if (index >= 0) {
      _items[index].qty++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void decrease(Product product) {
    final index = _items.indexWhere((i) => i.product.id == product.id);
    if (index >= 0) {
      if (_items[index].qty > 1) {
        _items[index].qty--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void remove(Product product) {
    _items.removeWhere((i) => i.product.id == product.id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}