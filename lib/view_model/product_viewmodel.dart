import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presyo/model/product.dart';

class ProductViewModel extends ChangeNotifier {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<Product> _products;

  Future<Product> get products => _products;

  Future<void> addProduct(Product product) async {
    var ref = await firebaseFirestore.collection('products').doc(product.sku).set(jsonDecode(jsonEncode(product)));
    return ref;
  }

   getProduct(String searchString) {
    var ref = firebaseFirestore
        .collection('products')
        .doc(searchString).get().then((value) => Product.fromFirestore(value));

     // var ref = firebaseFirestore.collection('products').where("sku", isEqualTo: searchString).snapshots().map((event) => event.docs.map((e) => Product.fromFirestore(e)).toList());

     _products = ref;
     notifyListeners();
  }

  Future<void> updateProduct(Product product) async{
    var ref = await firebaseFirestore.collection('products').doc(product.sku).update(jsonDecode(jsonEncode(product)));
    return ref;
  }

  deleteProduct(String productId) {
    firebaseFirestore.collection('products').doc(productId).delete();
  }

}
