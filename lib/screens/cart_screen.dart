import 'package:flutter/material.dart';

import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/orders.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_list_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key key}) : super(key: key);
  static const String routeName = '/cart-screen';
  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    final List<CartItem> valueList = cartData.items.values.toList();

    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '₹${cartData.totalCost.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .titleMedium
                              .color),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  OrderButton(cartData: cartData)
                ],
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (context, i) => CartListItem(
              id: valueList[i].id,
              productId: cartData.items.keys.toList()[i],
              price: valueList[i].price,
              quantity: valueList[i].quantity,
              title: valueList[i].title,
            ),
            itemCount: cartData.itemCount,
          ))
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cartData,
  }) : super(key: key);

  final Cart cartData;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cartData.totalCost <= 0 || isLoading)
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cartData.items.values.toList(),
                widget.cartData.totalCost,
              );
              setState(() {
                isLoading = false;
              });
              widget.cartData.clearCart();
            },
      child: isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
    );
  }
}
