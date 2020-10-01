import 'package:flutter/material.dart';
import 'package:presyo/model/product.dart';
import 'package:presyo/view_model/product_viewmodel.dart';
import 'package:provider/provider.dart';

Future<void> deleteProductDialog(BuildContext context, Product product) async {
  var productViewModel = Provider.of<ProductViewModel>(context, listen: false);

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete'),
          content: Text('Are you sure want to delete ${product.description}?'),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
            FlatButton(
              onPressed: () {
                productViewModel.deleteProduct(product.docId).then((value) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/search', (route) => false);
                  // Navigator.pop(context);
                });
              },
              child: Text('Yes'),
            )
          ],
        );
      });
}
