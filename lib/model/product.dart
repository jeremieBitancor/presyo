import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presyo/model/product_price.dart';

class Product {
  final String docId;
  final String sku;
  final String description;
  final ProductPrice price;
  final List<String> indexString;

  Product(
      {this.docId, this.sku, this.description, this.price, this.indexString});

  factory Product.fromFirestore(DocumentSnapshot docSnap) {
    Map data = docSnap.data();
    return Product(
        docId: docSnap.id,
        description: data['description'],
        sku: data['sku'],
        price: ProductPrice.fromMap(data['price']));
  }
  Map<String, dynamic> toJson() => {
        'description': description,
        'sku': sku,
        'price': price,
        'indexString': indexString
      };
}
