import 'package:flutter/material.dart';
import 'package:presyo/view/add_product.dart';
import 'package:presyo/view/edit_product.dart';
import 'package:presyo/view_model/product_viewmodel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchController = TextEditingController();
  var searchString;

  @override
  void initState() {
    super.initState();
    searchController.addListener(searchValue);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    searchController.dispose();
    super.dispose();
  }

  searchValue() {
    // searchString = searchController.text;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final productVM = Provider.of<ProductViewModel>(context);

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 80,
          title: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFEEF0F2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: searchController,
                    cursorColor: Color(0xFF323031),
                    style: TextStyle(color: Color(0xFF000000)),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xFF7F7979),
                        ),
                        suffixIcon: searchController.text != ''
                            ? IconButton(
                                icon: Icon(Icons.clear),
                                color: Color(0xFF7F7979),
                                onPressed: () {
                                  searchController.clear();
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        hintText: "Search",
                        hintStyle: TextStyle(color: Color(0xFF7F7979))),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    color: Color(0xFF470FF4),
                    borderRadius: BorderRadius.circular(15)),
                child: IconButton(
                  onPressed: () {},
                  icon: FaIcon(FontAwesomeIcons.camera),
                  color: Colors.white,
                ),
              )
            ],
          )),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        child: StreamBuilder(
          stream: productVM.getProduct(searchController.text),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error');
            } else {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('None');
                  break;

                case ConnectionState.waiting:
                  return Container(
                      child: Center(
                    child: CircularProgressIndicator(),
                  ));
                  break;

                case ConnectionState.active:
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
                                color: Color(0xFFEEF0F2),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(snapshot.data[index].sku,
                                      style: TextStyle(fontSize: 20)),
                                  Text(
                                    snapshot.data[index].description
                                        .toString()
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Retail price'),
                                            Text(
                                              snapshot.data[index].price.retail
                                                  .toString(),
                                              style: TextStyle(fontSize: 20),
                                            )
                                          ]),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Wholesale price'),
                                            Text(
                                                snapshot
                                                    .data[index].price.wholesale
                                                    .toString(),
                                                style: TextStyle(fontSize: 20))
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
          backgroundColor: Color(0xFF470FF4),
          onPressed: () {
            Navigator.of(context).pushNamed('/addProduct');
          },
          child: Icon(Icons.add)),
    );
  }
}
