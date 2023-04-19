import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> orderedProducts;
  final DateTime dateTime;
  OrderItem({
    @required this.amount,
    @required this.dateTime,
    @required this.id,
    @required this.orderedProducts,
  });
}

class Orders with ChangeNotifier {
  final String authToken;
  final String userId;
  Orders(this.authToken, this.userId, this._orders);
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse(
        'https://flutter-update-4def7-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final response = await http.get(url);
    print(json.decode(response.body));
    final List<OrderItem> loadedProducts = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedProducts.add(
        OrderItem(
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          id: orderId,
          orderedProducts:
              (orderData['cartProducts'] as List<dynamic>).map((item) {
            return CartItem(
              id: item['id'],
              price: item['price'],
              quantity: item['quantity'],
              title: item['title'],
            );
          }).toList(),
        ),
      );
    });
    _orders = loadedProducts.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://flutter-update-4def7-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final timeStamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'cartProducts': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList()
        }));
    _orders.insert(
      0,
      OrderItem(
          amount: total,
          dateTime: timeStamp,
          id: json.decode(response.body)['name'],
          orderedProducts: cartProducts),
    );
    notifyListeners();
  }
}
