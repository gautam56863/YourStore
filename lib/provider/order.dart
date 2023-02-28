import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItems> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.dateTime,
    @required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  final String token;
  final String userId;
  Orders(this.token, this.userId, this._orders);
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrder() async {
    final url = Uri.parse(
        'https://yourstore-1469f-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token');
    final response = await http.get(url);
    final List<OrderItem> loadedOrder = [];
    final extractedOrder = json.decode(response.body) as Map<String, dynamic>;
    if (extractedOrder == null) {
      return;
    }
    extractedOrder.forEach((orderId, orderProd) {
      loadedOrder.add(
        OrderItem(
          id: orderId,
          amount: orderProd['amount'],
          dateTime: DateTime.parse(orderProd['dateTime']),
          products: (orderProd['products'] as List<dynamic>)
              .map(
                (items) => CartItems(
                  id: items['id'],
                  title: items['title'],
                  quantity: items['quantity'],
                  price: items['price'],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrder.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItems> cartItems, double total) async {
    {
      final dateTime = DateTime.now();
      final url = Uri.parse(
          'https://yourstore-1469f-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token');

      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'dateTime': dateTime.toIso8601String(),
          'products': cartItems
              .map((ci) => {
                    'id': ci.id,
                    'title': ci.title,
                    'quantity': ci.quantity,
                    'price': ci.price,
                  })
              .toList(),
        }),
      );

      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: DateTime.now(),
          products: cartItems,
        ),
      );
      notifyListeners();
    }
  }
}
