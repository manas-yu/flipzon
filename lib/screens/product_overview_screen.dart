// ignore_for_file: missing_required_param

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:flutter_complete_guide/widgets/products_grid.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

enum FilterOptions {
  favorites,
  all,
}

class ProductOverviewScreen extends StatelessWidget {
  ProductOverviewScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Flipzon'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              if (selectedValue == FilterOptions.favorites) {
                productData.showFavorites();
              } else {
                productData.showAll();
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text('Favorites Only'),
                  value: FilterOptions.favorites,
                ),
                PopupMenuItem(
                  child: Text('Show All'),
                  value: FilterOptions.all,
                ),
              ];
            },
            icon: Icon(Icons.more_vert),
          )
        ],
      ),
      body: ProductsGrid(),
    );
  }
}
