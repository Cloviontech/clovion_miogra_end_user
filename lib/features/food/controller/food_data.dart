import 'package:flutter/material.dart';
import 'package:miogra/features/food/models_foods/category_based_food_model.dart';

// import '../cart_data/product.dart';

class Fooddata extends ChangeNotifier {
  // product for sale
  // final List<Product> _shop = [
  //   Product(
  //     name: "Product 1",
  //     price: 99.99,
  //     description: 'item decription 1',
  //     //  imagePath: '',
  //   ),
  //   Product(
  //     name: "Product 2",
  //     price: 99.99,
  //     description: 'item decription 2',
  //     //  imagePath: '',
  //   ),
  //   Product(
  //     name: "Product 3",
  //     price: 99.99,
  //     description: 'item decription 3',
  //     //  imagePath: '',
  //   ),
  //   Product(
  //     name: "Product 4",
  //     price: 99.99,
  //     description: 'item decription 4',
  //     //  imagePath: '',
  //   )
  // ];

  //  user cart
  List<CategoryBasedFood> _cart = [];

  //  user cart with quantity
  List _cartWithQuantity = [];

// // get product list
//   List<CategoryBasedFood> get shop => _shop;

// get user cart
  List<CategoryBasedFood> get cart => _cart;

  List get cartwithQuantity => _cartWithQuantity;


  // ////////
  List<List<dynamic>> _productsInMainCart = [];
  //
  List get productsInMainCart => _productsInMainCart;
  // add item to cart
  void addToMainCart(List<List<dynamic>> items) {

    _productsInMainCart.add(items);
    notifyListeners();
  }
  // ////////



  //////////
  List<List<dynamic>> _shoppingCart = [];
  /////////
  List get shoppingCart => _shoppingCart;
  // add item to cart
  void addToShoppingCart(List<List<dynamic>> items) {
    _shoppingCart.add(items);
    notifyListeners();
  }
  //////////






// add item to cart
  void addToCart(CategoryBasedFood item) {
    _cart.add(item);
    notifyListeners();
  }

  void addToCartwithQuantity(Map<String, dynamic> productWithQuantity) {
    _cartWithQuantity.add(productWithQuantity);
    notifyListeners();
  }

  // remove item from cart
  void removeFromCart(CategoryBasedFood item) {
    _cart.remove(item);

    notifyListeners();
  }

  // remove item from cart
  void removeFromCartWithQuantity(Map<String, dynamic> productWithQuantity) {
    _cartWithQuantity.remove(productWithQuantity);

    notifyListeners();
  }


  int _quantity = 0;

  int get quantity => _quantity;


  void incrementQuantity () {
    _quantity++;
    notifyListeners();
  }

  void decrementQuantity () {
    _quantity--;
    notifyListeners();
  }


}
