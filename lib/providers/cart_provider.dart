import 'package:flutter/foundation.dart';

import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  static const int selectionLimit = 3;

  final Set<String> _selectedIds = <String>{};

  List<Product> get selectedProducts => Product.catalog
      .where((product) => _selectedIds.contains(product.id))
      .toList(growable: false);

  int get selectedCount => _selectedIds.length;

  bool get canContinue => selectedCount == selectionLimit;

  double get total =>
      selectedProducts.fold<double>(0, (sum, product) => sum + product.price);

  bool isSelected(String productId) => _selectedIds.contains(productId);

  /// Alterna la selección y evita que el carrito supere los tres productos.
  /// Devuelve false cuando el producto no pudo agregarse por haber llegado
  /// al límite.
  bool toggleProduct(String productId) {
    if (_selectedIds.remove(productId)) {
      notifyListeners();
      return true;
    }

    if (_selectedIds.length >= selectionLimit) return false;

    _selectedIds.add(productId);
    notifyListeners();
    return true;
  }
}
