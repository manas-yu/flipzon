import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_complete_guide/providers/orders.dart';
import 'package:intl/intl.dart';

class OrderItemTile extends StatefulWidget {
  final OrderItem order;
  OrderItemTile(this.order);

  @override
  State<OrderItemTile> createState() => _OrderItemTileState();
}

class _OrderItemTileState extends State<OrderItemTile> {
  var _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('₹${widget.order.amount.toStringAsFixed(2)}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                  print(_isExpanded);
                });
              },
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
            ),
          ),
          if (_isExpanded == true)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.order.orderedProducts.length * 20.0 + 10, 100),
              child: ListView(
                children: [
                  ...widget.order.orderedProducts
                      .map(
                        (prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              prod.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${prod.quantity}x \$${prod.price}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ],
              ),
            )
        ],
      ),
    );
  }
}
