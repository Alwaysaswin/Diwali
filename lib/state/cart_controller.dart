import 'package:flutter/material.dart';
import '../models/product.dart';

class CartController extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get mrpTotal => _items.fold(
        0,
        (sum, item) => sum + (item.product.mrp * item.quantity),
      );

  double get discountTotal => _items.fold(
        0,
        (sum, item) => sum + ((item.product.mrp - item.product.price) * item.quantity),
      );

  double get netTotal => _items.fold(
        0,
        (sum, item) => sum + (item.product.price * item.quantity),
      );

  double get minimumOrderThreshold => 1500.0;

  double get progressToMinimum => 
      (netTotal / minimumOrderThreshold).clamp(0.0, 1.0);

  bool get meetsMinimumOrder => netTotal >= minimumOrderThreshold;

  void addToCart(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void updateQuantity(Product product, int quantity) {
    if (quantity <= 0) {
      _items.removeWhere((item) => item.product.id == product.id);
    } else {
      final index = _items.indexWhere((item) => item.product.id == product.id);
      if (index >= 0) {
        _items[index].quantity = quantity;
      }
    }
    notifyListeners();
  }

  int getQuantity(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    return index >= 0 ? _items[index].quantity : 0;
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
