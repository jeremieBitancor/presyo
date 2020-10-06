import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:presyo/model/product.dart';
import 'package:presyo/model/product_price.dart';
import 'package:presyo/view_model/product_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:barcode_scan/barcode_scan.dart';

class AddProduct extends StatefulWidget {
  AddProduct({Key key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final skuController = TextEditingController();
  final descController = TextEditingController();
  final retailPriceController = TextEditingController();
  final wholesalePriceController = TextEditingController();

  var isLoading = false;

  @override
  void dispose() {
    skuController.dispose();
    descController.dispose();
    retailPriceController.dispose();
    wholesalePriceController.dispose();
    super.dispose();
  }

  void scan() async {
    var result = await BarcodeScanner.scan();

    print(result.type); // The result type (barcode, cancelled, failed)
    print(result.rawContent); // The barcode content
    print(result.format); // The barcode format (as enum)
    print(result
        .formatNote); // If a unknown format was scanned this field contains a note

    skuController.text = result.rawContent;
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
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 30),
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: formKey,
          child: Column(children: [
            Row(children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(bottom: 6),
                  child: TextFormField(
                    controller: skuController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        filled: true,
                        hintText: "SKU",
                        isDense: true,
                        contentPadding: EdgeInsets.all(15),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(15))),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Invalid";
                      }
                      formKey.currentState.save();
                      return null;
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 6, left: 6),
                child: IconButton(
                  onPressed: scan,
                  icon: FaIcon(
                    FontAwesomeIcons.camera,
                  ),
                  color: Colors.blue[900],
                ),
              )
            ]),
            Container(
              margin: EdgeInsets.only(bottom: 6),
              child: TextFormField(
                controller: descController,
                decoration: InputDecoration(
                    filled: true,
                    isDense: true,
                    contentPadding: EdgeInsets.all(15),
                    hintText: "Description",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(15))),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Invalid';
                  }
                  formKey.currentState.save();
                  return null;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 6),
              child: TextFormField(
                controller: retailPriceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                    filled: true,
                    hintText: "Retail price",
                    isDense: true,
                    contentPadding: EdgeInsets.all(15),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(15))),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Invalid";
                  }
                  formKey.currentState.save();
                  return null;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 6),
              child: TextFormField(
                controller: wholesalePriceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                    filled: true,
                    hintText: "Wholesale price",
                    isDense: true,
                    contentPadding: EdgeInsets.all(15),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(15))),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Invalid";
                  }
                  formKey.currentState.save();
                  return null;
                },
              ),
            ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[900],
        onPressed: () {
          if (formKey.currentState.validate()) {
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

            setState(() {
              isLoading = true;
            });

            productViewModel.addProduct(product).then((value) {
              setState(() {
                isLoading = false;
              });

              final snackbar = SnackBar(
                content: Text('$desc added.'),
              );
              scaffoldKey.currentState.showSnackBar(snackbar);
              skuController.clear();
              descController.clear();
              retailPriceController.clear();
              wholesalePriceController.clear();
            });
          }
        },
        child: isLoading
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : Icon(Icons.check),
      ),
    );
  }
}
