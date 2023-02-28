import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/splash_screen.dart';
import './screens/products_overview.dart';
import './screens/product_detail.dart';
import './provider/products.dart';
import './provider/cart.dart';
import './screens/cart_screen.dart';
import './provider/order.dart';
import './screens/order_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './provider/Auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProduct) => Products(
            auth.token,
            auth.userId,
            previousProduct == null ? [] : previousProduct.items,
          ),
          // create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousorders) => Orders(
            auth.token,
            auth.userId,
            previousorders == null ? [] : previousorders.orders,
          ),
          // create: (ctx) => Products(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.teal,
            accentColor: Colors.amberAccent.shade400,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? ProductsOverview()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetail.routeName: (ctx) => ProductDetail(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProducts.routeName: (ctx) => UserProducts(),
            EditProduct.routeName: (ctx) => EditProduct(),
          },
        ),
      ),
    );
  }
}
