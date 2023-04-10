// ignore_for_file: missing_required_param

import 'dart:convert';

import 'package:flutter/material.dart';
import '../providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];
  // var _favoritesOnly = false;
  // void showFavorites() {
  //   _favoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _favoritesOnly = false;
  //   notifyListeners();
  // }
  List<Product> get favorites {
    return items.where((item) => item.isFavorite).toList();
  }

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere(
      (prod) => id == prod.id,
    );
  }

  void addProduct(Product product) {
    final url = Uri.parse(
        'https://flutter-update-4def7-default-rtdb.firebaseio.com/product.json');
    http
        .post(
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'isFav': product.isFavorite,
        'imageUrl': product.imageUrl,
      }),
    )
        .then((response) {
      print(json.decode(response.body));
      final newProduct = Product(
        description: product.description,
        id: json.decode(response.body)['name'],
        price: product.price,
        title: product.title,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    });
  }

  void updateProduct(String id, Product newProduct) {
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    _items[productIndex] = newProduct;
    notifyListeners();
  }

  void removeProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
