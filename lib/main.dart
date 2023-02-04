import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview.dart';
import './screens/product_detail.dart';
import './provider/products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Products(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          accentColor: Colors.amberAccent.shade400,
          fontFamily: 'Lato',
        ),
        home: ProductsOverview(),
        routes: {
          ProductDetail.routeName: (ctx) => ProductDetail(),
        },
      ),
    );
  }
}
