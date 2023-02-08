import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_items.dart';
import '../provider/products.dart';

class Products_grid extends StatelessWidget {
  final bool showfavs;
  Products_grid(this.showfavs);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context, listen: false);
    final product = showfavs ? productsData.favoriteItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsetsDirectional.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: product[i],
        child: ProductItem(
            // product[i].id,
            // product[i].title,
            // product[i].imageUrl,
            ),
      ),
      itemCount: product.length,
    );
  }
}
