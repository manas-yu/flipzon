import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:http/http.dart' as http;

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
    this.isFavorite = false,
    @required this.price,
    @required this.title,
    @required this.imageUrl,
  });
  Future<void> toggleFavorites(String token) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final url = Uri.parse(
          'https://flutter-update-4def7-default-rtdb.firebaseio.com/product/$id.json?auth=$token');
      final response =
          await http.patch(url, body: json.encode({'isFav': isFavorite}));
      if (response.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
        throw HttpException('Error in changing favorite');
      }
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
      throw HttpException('Error in changing favorite');
    }
  }
}
