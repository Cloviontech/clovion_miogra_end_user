import 'package:flutter/material.dart';

import 'product.dart';

class Shop extends ChangeNotifier {
  // product for sale
  final List<Product> _shop = [
    Product(
      name: "Product 1",
      price: 99.99,
      description: 'item decription 1',
      //  imagePath: '',
    ),
    Product(
      name: "Product 2",
      price: 99.99,
      description: 'item decription 2',
      //  imagePath: '',
    ),
    Product(
      name: "Product 3",
      price: 99.99,
      description: 'item decription 3',
      //  imagePath: '',
    ),
    Product(
      name: "Product 4",
      price: 99.99,
      description: 'item decription 4',
      //  imagePath: '',
    )
  ];

  //  user cart
  List<Product> _cart = [];

// get product list
  List<Product> get shop => _shop;

// get user cart
  List<Product> get cart => _cart;

// add item to cart
  void addToCart(Product item) {
    _cart.add(item);
    notifyListeners();
  }

  // remove item from cart
  void removeFromCart(Product item) {
    _cart.remove(item);
    notifyListeners();
  }
}
