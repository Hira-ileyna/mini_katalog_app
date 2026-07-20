import 'package:flutter/material.dart';
import 'package:mini_katalog_app/models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartService extends ValueNotifier<List<CartItem>> {
  CartService._internal() : super([]);
  static final CartService instance = CartService._internal();

  // Sepete Ürün Ekle
  void addToCart(Product product) {
    final existingIndex = value.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      value[existingIndex].quantity += 1;
    } else {
      value.add(CartItem(product: product));
    }
    notifyListeners();
  }

  // Sepetten Ürün Çıkar / Adet Azalt
  void removeFromCart(Product product) {
    final existingIndex = value.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      if (value[existingIndex].quantity > 1) {
        value[existingIndex].quantity -= 1;
      } else {
        value.removeAt(existingIndex);
      }
    }
    notifyListeners();
  }

  // Ürünü Tamamen Sepetten Sil
  void deleteItem(String productId) {
    value.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  // Sepeti Temizle
  void clearCart() {
    value.clear();
    notifyListeners();
  }

  // Toplam Tutar
  double get totalAmount {
    double total = 0.0;
    for (var item in value) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  // Toplam Ürün Adedi
  int get itemCount {
    int count = 0;
    for (var item in value) {
      count += item.quantity;
    }
    return count;
  }
}