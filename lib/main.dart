import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/product_detail_screen.dart';
import 'package:flutter_complete_guide/screens/product_overview_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      //*don't use .value when instantiating a class
      create: (ctx) => Products(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyShop',
        theme: ThemeData(
          fontFamily: 'Lato',
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
              .copyWith(secondary: Colors.deepOrange),
        ),
        home: ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen()
        },
      ),
    );
  }
}
