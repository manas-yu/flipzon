import 'package:flutter_complete_guide/providers/products.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import 'package:flutter/material.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  ProductsGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavs ? productsData.favorites : productsData.items;
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 3 / 2,
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) {
        return ChangeNotifierProvider.value(
          //*here we use existing value therefore use .value..... it is also good for .builder list/grids
          value: products[i],
          child: ProductItem(
              // id: products[i].id,
              // title: products[i].title,
              // imageUrl: products[i].imageUrl,

              ),
        );
      },
      itemCount: products.length,
    );
  }
}
