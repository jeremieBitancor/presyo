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

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    var productViewModel = Provider.of<ProductViewModel>(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        // toolbarHeight: 80,
        iconTheme: IconThemeData(color: Color(0xFF323B20)),
        title: Text(
          'Edit',
          style: TextStyle(color: Color(0xFF323B20)),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            color: Color(0xFF819C4B),
            onPressed: () {
              deleteProductDialog(context, widget.product);
            },
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        'SKU',
                        style: TextStyle(color: Color(0xFF323B20)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 12, top: 6),
                      child: TextFormField(
                        initialValue: widget.product.sku,
                        readOnly: true,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFF1EEE5),
                          isDense: true,
                          contentPadding: EdgeInsets.all(15),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFF1EEE5)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFF1EEE5)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text('Description',
                          style: TextStyle(color: Color(0xFF323B20))),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 12, top: 6),
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
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFF1EEE5),
                          isDense: true,
                          contentPadding: EdgeInsets.all(15),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFF1EEE5)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFF1EEE5)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Retail price',
                        style: TextStyle(color: Color(0xFF323B20)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 12, top: 6),
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
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFF1EEE5),
                          isDense: true,
                          contentPadding: EdgeInsets.all(15),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFF1EEE5)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFF1EEE5)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Wholesale price',
                        style: TextStyle(color: Color(0xFF323B20)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 6),
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
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFF1EEE5),
                          isDense: true,
                          contentPadding: EdgeInsets.all(15),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFF1EEE5)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFF1EEE5)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF819C4B),
        onPressed: () {
          if (formKey.currentState.validate()) {
            List<String> newIndexString = [];

            for (int i = 1; i < this.description.length; i++) {
              newIndexString.add(this.description.substring(0, i).toString());
            }

            var newPrice = ProductPrice(
                retail: this.retailPrice, wholesale: this.wholesalePrice);
            var newProduct = Product(
                docId: widget.product.docId,
                sku: widget.product.sku,
                description: this.description,
                price: newPrice,
                indexString: newIndexString);

            setState(() {
              isLoading = true;
            });

            productViewModel.updateProduct(newProduct).then((value) {
              setState(() {
                isLoading = false;
              });
              final snackbar = SnackBar(
                content: Text('$description updated'),
              );
              scaffoldKey.currentState.showSnackBar(snackbar);
            });
          }
        },
        child: isLoading
            ? CircularProgressIndicator(backgroundColor: Colors.white)
            : Icon(
                Icons.edit,
              ),
      ),
    );
  }
}
