import 'package:flutter/material.dart';
import 'package:presyo/view_model/search_product_viewmodel.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    final SearchProductViewModel searchProductVM =
        Provider.of<SearchProductViewModel>(context);

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: TextField(
            onChanged: (text) {
              searchProductVM.setSearchString(text);
            },
            autofocus: true,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search",
                hintStyle: TextStyle(color: Colors.white70)),
          )),
      body: Text(searchProductVM.searchString),
    );
  }
}
