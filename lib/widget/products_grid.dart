import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_items.dart';
import '../provider/products.dart';

class Products_grid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final product = productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider(
        create: (c) => product[i],
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
