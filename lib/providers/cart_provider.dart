import 'package:flutter/foundation.dart';

import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  static const int selectionLimit = 3;

  // Two products are selected initially to show the locked 2-of-3 state from
  // the reference. The learner must select one more before continuing.
  final Set<String> _selectedIds = {'backpack', 'headphones'};

  List<Product> get selectedProducts => Product.catalog
      .where((product) => _selectedIds.contains(product.id))
      .toList(growable: false);

  int get selectedCount => _selectedIds.length;

  bool get canContinue => selectedCount == selectionLimit;

  int get total => selectedProducts.fold<int>(
        0,
        (sum, product) => sum + product.price,
      );

  bool isSelected(String productId) => _selectedIds.contains(productId);

  /// Toggles a product, keeping the shared selection at three items or fewer.
  /// Returns false when a fourth item cannot be added.
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
