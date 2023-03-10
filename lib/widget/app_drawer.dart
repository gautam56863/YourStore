import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/order_screen.dart';
import '../screens/user_products_screen.dart';
import '../provider/Auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        AppBar(
          title: Text('Hello Friend!'),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text('Shop'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text('Orders'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text('Mange Products'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(UserProducts.routeName);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Logout'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/');
            // Navigator.of(context).pushReplacementNamed(UserProducts.routeName);
            Provider.of<Auth>(context, listen: false).logOut();
          },
        ),
      ],
    ));
  }
}
