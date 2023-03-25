import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';

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
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0,
      OrderItem(
          amount: total,
          dateTime: DateTime.now(),
          id: DateTime.now().toString(),
          orderedProducts: cartProducts),
    );
    notifyListeners();
  }
}
