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
  //don't initialize in build class as it will keep assigning it false value when set state is triggered
  var _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _isExpanded
          ? min(widget.order.orderedProducts.length * 20.0 + 110, 200)
          : 80,
      child: Card(
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
            // if (_isExpanded == true)
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: _isExpanded
                  ? min(widget.order.orderedProducts.length * 20.0 + 10, 100)
                  : 0,
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
      ),
    );
  }
}
