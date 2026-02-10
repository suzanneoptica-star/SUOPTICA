
import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get subtotal {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  bool get hasLenses {
    // Verificar si hay items con cristales configurados o productos de categoría 'Cristales'
    return _items.any((item) => 
      item.product.category == 'Cristales' || 
      (item.lensType != null && item.lensType!.price > 0)
    );
  }
}
