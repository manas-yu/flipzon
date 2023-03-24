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

class ProductOverviewScreen extends StatefulWidget {
  ProductOverviewScreen({Key key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var favoritesOnly = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flipzon'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.favorites) {
                  favoritesOnly = true;
                } else {
                  favoritesOnly = false;
                }
              });
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
      body: ProductsGrid(favoritesOnly),
    );
  }
}
