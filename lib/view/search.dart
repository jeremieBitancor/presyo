import 'package:flutter/material.dart';
import 'package:presyo/view/edit_product.dart';
import 'package:presyo/view_model/product_viewmodel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:barcode_scan/barcode_scan.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchController = TextEditingController();
  var searchString;
  var searchSKU;

  @override
  void initState() {
    super.initState();
    searchController.addListener(searchValue);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  searchValue() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final productVM = Provider.of<ProductViewModel>(context);

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: Row(
            children: [
              Expanded(
                child: TextField(
                  minLines: 1,
                  controller: searchController,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  onSubmitted: (value) {
                    productVM.getProduct(value);
                  },
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blue[800],
                      isDense: true,
                      contentPadding: EdgeInsets.all(10),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(15)),
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.white)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: IconButton(
                  onPressed: () async {
                    var result = await BarcodeScanner.scan();

                    productVM.getProductBySKU(result.rawContent);
                    searchController.text = result.rawContent;
                  },
                  icon: FaIcon(
                    FontAwesomeIcons.camera,
                  ),
                ),
              )
            ],
          )),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        child: StreamBuilder(
          stream: productVM.products,
          builder: (context, snapshot) {
            print(snapshot);
            if (snapshot.hasError) {
              return Text('Error');
            } else {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Center(
                      child: Text(
                    'Search for product.',
                    style: TextStyle(color: Color(0xFF7F7979), fontSize: 20),
                  ));
                  break;

                case ConnectionState.waiting:
                  if (!snapshot.hasData) {
                    return Container(
                      child: Center(
                        child: Text(
                          "No product found.",
                          style:
                              TextStyle(color: Color(0xFF7F7979), fontSize: 20),
                        ),
                      ),
                    );
                  }

                  return Container(
                      child: Center(
                    child: CircularProgressIndicator(),
                  ));
                  break;

                case ConnectionState.active:
                  if (snapshot.data.length == 0) {
                    return Container(
                      child: Center(
                        child: Text(
                          "No product found.",
                          style:
                              TextStyle(color: Color(0xFF7F7979), fontSize: 20),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProduct(
                                          product: snapshot.data[index],
                                        )));
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      offset: Offset(1, 1),
                                      spreadRadius: 1,
                                      blurRadius: 1),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(snapshot.data[index].sku,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF323B20),
                                          fontWeight: FontWeight.w400)),
                                  Text(
                                    snapshot.data[index].description.toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF323B20)),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Retail price',
                                              style: TextStyle(
                                                  color: Color(0xFF323B20)),
                                            ),
                                            Text(
                                              snapshot.data[index].price.retail
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Color(0xFF323B20)),
                                            )
                                          ]),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Wholesale price',
                                              style: TextStyle(
                                                  color: Color(0xFF323B20)),
                                            ),
                                            Text(
                                                snapshot
                                                    .data[index].price.wholesale
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Color(0xFF323B20)))
                                          ])
                                    ],
                                  )
                                ]),
                          ),
                        );
                      });
                  break;

                case ConnectionState.done:
                  return Text('Done');
                  break;
              }
              return Container();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue[900],
          onPressed: () {
            Navigator.of(context).pushNamed('/addProduct');
          },
          child: Icon(Icons.add)),
    );
  }
}
