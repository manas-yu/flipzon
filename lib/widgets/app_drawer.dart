import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';

import 'package:flutter_complete_guide/screens/orders_screen.dart';
import 'package:flutter_complete_guide/screens/user_product_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello!'),
            automaticallyImplyLeading: false,
          ),
          Divider(
            thickness: 2,
          ),
          ListTile(
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
            leading: Icon(Icons.shop),
            title: Text('Shop'),
          ),
          Divider(
            thickness: 2,
          ),
          ListTile(
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrdersScreen.routeName),
            leading: Icon(Icons.payment),
            title: Text('Orders'),
          ),
          Divider(
            thickness: 2,
          ),
          ListTile(
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(UserProductScreen.routeName),
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
          ),
          Divider(
            thickness: 2,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
