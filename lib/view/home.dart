import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:presyo/model/product.dart';
import 'package:presyo/view/add_product.dart';
import 'package:presyo/view/edit_product.dart';
import 'package:presyo/view_model/product_viewmodel.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // String val;
  var snapshot;

  @override
  Widget build(BuildContext context) {
    final ProductViewModel productViewModel =
        Provider.of<ProductViewModel>(context);

    return Scaffold(
      body: Column(children: [
        Container(
          height: 100,
          decoration: BoxDecoration(color: Colors.blue[900]),
          child: SafeArea(
            child: Container(
                padding: EdgeInsets.only(left: 10),
                margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                decoration: BoxDecoration(color: Colors.blue[800]),
                child: Center(
                    child: TextField(
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    productViewModel.getProduct(value);
                    //  val = await value;
                    // print('$val');
                    // setState(() {
                    //   snapshot = productViewModel.getProduct(value);
                    // });
                    // print("Snapshot: $snapshot");
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      border: InputBorder.none,
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.white)),
                ))),
          ),
        ),
        FutureBuilder(
            future: productViewModel.products,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  padding: EdgeInsets.only(top: 50),
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                print(snapshot.data.docId);
                Product product = snapshot.data;

                return GestureDetector(
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EditProduct(product: snapshot.data,)));
                  },
                  child: Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF4CA9DF), Color(0xFF292E91)]),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.sku,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          product.description.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Retail price',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                Text(
                                  product.price.retail.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Wholesale price',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                Text(
                                  product.price.wholesale.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }
              return Container(
                  padding: EdgeInsets.only(top: 50),
                  child: Text('No product found.', style: TextStyle(color: Colors.black54, fontSize: 20),));
            }),
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[900],
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddProduct()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
