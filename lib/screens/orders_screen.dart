import 'package:flutter/material.dart';

import 'package:flutter_complete_guide/providers/orders.dart';
import 'package:flutter_complete_guide/widgets/app_drawer.dart';
import 'package:flutter_complete_guide/widgets/order_item_tile.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key key}) : super(key: key);

  static const String routeName = '/orders-screen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future ordersFuture;
  Future obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchOrders();
  }

  @override
  void initState() {
    ordersFuture = obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: ordersFuture,
          builder: (ctx, dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapShot.error != null) {
                return Center(
                  child: Text('An error occurred!'),
                );
              } else {
                return Consumer<Orders>(
                  builder: (context, orderData, child) {
                    return ListView.builder(
                      itemCount: orderData.orders.length,
                      itemBuilder: (context, index) {
                        return OrderItemTile(orderData.orders[index]);
                      },
                    );
                  },
                );
              }
            }
          },
        ));
  }
}
