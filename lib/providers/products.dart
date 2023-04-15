// ignore_for_file: missing_required_param

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import '../providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final String authToken;
  final String userId;
  Products(this.authToken, this.userId, this._items);
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

  Future<void> fetchProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://flutter-update-4def7-default-rtdb.firebaseio.com/product.json?auth=$authToken&$filterString');
    //tryCatch not needed
    try {
      final response = await http.get(url);
      print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData == null) {
        return;
      }
      url = Uri.parse(
          'https://flutter-update-4def7-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          description: prodData['description'],
          id: prodId,
          price: prodData['price'],
          title: prodData['title'],
          imageUrl: prodData['imageUrl'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
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
        'https://flutter-update-4def7-default-rtdb.firebaseio.com/product.json?auth=$authToken');
    final response = await http.post(
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'creatorId': userId,
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
          'https://flutter-update-4def7-default-rtdb.firebaseio.com/product/$id.json?auth=$authToken');
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

  Future<void> removeProduct(String id) async {
    // _items.removeWhere((prod) => prod.id == id);
    final url = Uri.parse(
        'https://flutter-update-4def7-default-rtdb.firebaseio.com/product/$id.json?auth=$authToken');
    final existingProductIndex = _items.indexWhere(
      (prod) => prod.id == id,
    );
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    print(response.statusCode);
    //* http package only sends error for get and post while for others we make our own errors (if status code>=400 then there is an error)
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null;
  }
}
