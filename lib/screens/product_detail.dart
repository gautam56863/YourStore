import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products.dart';

class ProductDetail extends StatelessWidget {
  // final String title;
  // ProductDetail(this.title);
  static const routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findbyId(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
    );
  }
}
