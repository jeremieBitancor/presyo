import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:presyo/model/product.dart';
import 'package:presyo/model/product_price.dart';
import 'package:presyo/view/delete_product_dialog.dart';
import 'package:presyo/view_model/product_viewmodel.dart';
import 'package:provider/provider.dart';

class EditProduct extends StatefulWidget {
  final Product product;

  EditProduct({Key key, @required this.product}) : super(key: key);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // var sku;
  var description;
  var retailPrice;
  var wholesalePrice;

  @override
  Widget build(BuildContext context) {
    var productViewModel = Provider.of<ProductViewModel>(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        iconTheme: IconThemeData(color: Color(0xFF7F7979)),
        title: Text(
          'Edit',
          style: TextStyle(color: Color(0xFF7F7979)),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Color(0xFF470FF4),
            ),
            onPressed: () {
              if (formKey.currentState.validate()) {
                List<String> newIndexString = [];

                for (int i = 1; i < this.description.length; i++) {
                  newIndexString
                      .add(this.description.substring(0, i).toString());
                }

                var newPrice = ProductPrice(
                    retail: this.retailPrice, wholesale: this.wholesalePrice);
                var newProduct = Product(
                    sku: widget.product.sku,
                    description: this.description,
                    price: newPrice,
                    indexString: newIndexString);

                productViewModel.updateProduct(newProduct).then((value) {
                  final snackbar = SnackBar(
                    content: Text('$description updated'),
                  );
                  scaffoldKey.currentState.showSnackBar(snackbar);
                });
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            color: Color(0xFF470FF4),
            onPressed: () {
              // var productId = widget.product.sku;
              // productViewModel.deleteProduct(productId).then((value) {
              //   Navigator.pop(context);
              // });
              // Navigator.pop(context);
              // var productDesc = widget.product.description;
              deleteProductDialog(context, widget.product);
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   widget.product.sku,
              //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              // ),
              Container(
                padding: EdgeInsets.only(left: 20),
                margin: EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                    color: Color(0xFFEEF0F2),
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                  initialValue: widget.product.sku,
                  readOnly: true,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                margin: EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                    color: Color(0xFFEEF0F2),
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                  // controller: descController,
                  initialValue: widget.product.description,
                  onSaved: (value) {
                    description = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Invalid";
                    }
                    formKey.currentState.save();
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: "Description", border: InputBorder.none),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                margin: EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                    color: Color(0xFFEEF0F2),
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                  // controller: retailPriceController,
                  initialValue: widget.product.price.retail.toString(),
                  onSaved: (value) {
                    retailPrice = double.parse(value);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Invalid";
                    }
                    formKey.currentState.save();
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Retail price", border: InputBorder.none),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                margin: EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                    color: Color(0xFFEEF0F2),
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                  // controller: wholesalePriceController,
                  initialValue: widget.product.price.wholesale.toString(),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Invalid";
                    }
                    formKey.currentState.save();
                    return null;
                  },
                  onSaved: (value) {
                    wholesalePrice = double.parse(value);
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Wholesale price", border: InputBorder.none),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
