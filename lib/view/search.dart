import 'package:flutter/material.dart';
import 'package:presyo/view/add_product.dart';
import 'package:presyo/view_model/product_viewmodel.dart';
import 'package:presyo/view_model/search_product_viewmodel.dart';
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
          backgroundColor: Colors.blue[900],
          title: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white70),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      suffixIcon: searchController.text != ''
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              color: Colors.white,
                              onPressed: () {
                                searchController.clear();
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.white70)),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.camera_alt),
              )
            ],
          )),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: StreamBuilder(
          stream: productVM.getProduct(searchController.text),
          builder: (context, snapshot) {
            // if (snapshot.hasData) {
            //   print(snapshot.data.length);
            //   return Text('data');
            // }
            // return Container();

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
                  print(snapshot.data);
                  // return Text('Active');
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(
                              top: 2, bottom: 2, left: 15, right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(snapshot.data[index].description),
                              Text(snapshot.data[index].sku),
                              Divider(
                                thickness: 1,
                              )
                            ],
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
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddProduct()));
          },
          child: Icon(Icons.add)),
    );
  }
}
