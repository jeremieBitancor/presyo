import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presyo/model/product.dart';

class ProductViewModel extends ChangeNotifier {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // Future<Product> _products;

  // Future<Product> get products => _products;

  Stream<List<Product>> _products;
  Stream<List<Product>> get products => _products;

  Future<void> addProduct(Product product) async {
    var ref = await firebaseFirestore
        .collection('products')
        .add(jsonDecode(jsonEncode(product)));
    return ref;
  }

  // Stream<List<Product>>
  getProduct(String searchString) {
    var ref = firebaseFirestore
        .collection('products')
        .where('indexString', arrayContains: searchString)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Product.fromFirestore(e)).toList());

    _products = ref;
    notifyListeners();
    // return ref;
  }

  getProductBySKU(String sku) {
    var ref = firebaseFirestore
        .collection('products')
        .where('sku', isEqualTo: sku)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Product.fromFirestore(e)).toList());

    _products = ref;
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    // print(product.sku);
    var ref = await firebaseFirestore
        .collection('products')
        .doc(product.docId)
        .update(jsonDecode(jsonEncode(product)));
    return ref;
  }

  Future<void> deleteProduct(String productId) async {
    var ref =
        await firebaseFirestore.collection('products').doc(productId).delete();
    return ref;
  }
}
