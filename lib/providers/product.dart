import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  Product({
    @required this.description,
    @required this.id,
    this.isFavorite,
    @required this.price,
    @required this.title,
    @required this.imageUrl,
  });
  void toggleFavorites() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
