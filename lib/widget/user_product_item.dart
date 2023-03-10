import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../provider/products.dart';

class UserProduct extends StatelessWidget {
  final String id;
  final String title;
  final String imgUrl;

  UserProduct(this.id, this.title, this.imgUrl);
  @override
  Widget build(BuildContext context) {
    final scafflod = Scaffold.of(context);

    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imgUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProduct.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                } catch (error) {
                  // scafflod.showSnackBar(
                  //   SnackBar(
                  //     content: Text(
                  //       'Deleting Failed',
                  //       textAlign: TextAlign.center,
                  //     ),
                  //   ),
                  // );
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
