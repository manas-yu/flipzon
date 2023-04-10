// ignore_for_file: missing_required_param

import 'dart:convert';

import 'package:flutter/material.dart';
import '../providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    //dummy default data
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

  Future<void> fetchProducts() async {
    final url = Uri.parse(
        'https://flutter-update-4def7-default-rtdb.firebaseio.com/product.json');
    //tryCatch not needed
    try {
      final response = await http.get(url);
      print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          description: prodData['description'],
          id: prodId,
          price: prodData['price'],
          title: prodData['title'],
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://flutter-update-4def7-default-rtdb.firebaseio.com/product.json');
    final response = await http.post(
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'isFav': product.isFavorite,
        'imageUrl': product.imageUrl,
      }),
    );

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
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      final url = Uri.parse(
          'https://flutter-update-4def7-default-rtdb.firebaseio.com/product/$id.json');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          }));
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void removeProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
