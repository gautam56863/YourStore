import 'package:flutter/cupertino.dart';

class CartItems {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItems({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItems> _items = {};

  Map<String, CartItems> get items {
    return {..._items};
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (exixtingCardItem) => CartItems(
          id: exixtingCardItem.id,
          quantity: exixtingCardItem.quantity + 1,
          title: exixtingCardItem.title,
          price: exixtingCardItem.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItems(
          id: DateTime.now().toString(),
          quantity: 1,
          title: title,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  int get leng {
    return _items.length;
  }

  double get getAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }
}
