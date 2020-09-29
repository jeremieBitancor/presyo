import 'package:flutter/material.dart';
import 'package:presyo/model/product.dart';
import 'package:presyo/model/product_price.dart';
import 'package:presyo/view_model/product_viewmodel.dart';
import 'package:provider/provider.dart';

class AddProduct extends StatefulWidget {
  AddProduct({Key key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final skuController = TextEditingController();
  final descController = TextEditingController();
  final retailPriceController = TextEditingController();
  final wholesalePriceController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    skuController.dispose();
    descController.dispose();
    retailPriceController.dispose();
    wholesalePriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ProductViewModel productViewModel =
        Provider.of<ProductViewModel>(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Add',
          style: TextStyle(color: Color(0xFF7F7979)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        iconTheme: IconThemeData(color: Color(0xFF7F7979)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          Container(
            padding: EdgeInsets.only(left: 20),
            margin: EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
                color: Color(0xFFEEF0F2),
                borderRadius: BorderRadius.circular(15)),
            child: TextField(
              controller: skuController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "SKU",
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            margin: EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
                color: Color(0xFFEEF0F2),
                borderRadius: BorderRadius.circular(15)),
            child: TextField(
              controller: descController,
              decoration: InputDecoration(
                  hintText: "Description", border: InputBorder.none),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            margin: EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
                color: Color(0xFFEEF0F2),
                borderRadius: BorderRadius.circular(15)),
            child: TextField(
              controller: retailPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: "Retail price", border: InputBorder.none),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            margin: EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
                color: Color(0xFFEEF0F2),
                borderRadius: BorderRadius.circular(15)),
            child: TextField(
              controller: wholesalePriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: "Wholesale price", border: InputBorder.none),
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF470FF4),
        onPressed: () {
          String sku = skuController.text;
          String desc = descController.text;
          double retailPrice = double.parse(retailPriceController.text);
          double wholesalePrice = double.parse(wholesalePriceController.text);

          List<String> indexString = [];

          for (int i = 1; i < desc.length; i++) {
            indexString.add(desc.substring(0, i).toString());
          }

          var price =
              ProductPrice(retail: retailPrice, wholesale: wholesalePrice);
          var product = Product(
              sku: sku,
              description: desc,
              price: price,
              indexString: indexString);

          productViewModel.addProduct(product).then((value) {
            final snackbar = SnackBar(
              content: Text('$desc added.'),
            );
            scaffoldKey.currentState.showSnackBar(snackbar);
            skuController.clear();
            descController.clear();
            retailPriceController.clear();
            wholesalePriceController.clear();
          });
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
