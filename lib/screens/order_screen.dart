import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/order.dart' show Orders;
import '../widget/Order_items.dart';
import '../widget/app_drawer.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final OrderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Order"),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: OrderData.orders.length,
        itemBuilder: (ctx, i) => OrderItem(OrderData.orders[i]),
      ),
    );
  }
}
