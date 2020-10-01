import 'package:flutter/material.dart';
import 'package:presyo/view/add_product.dart';
import 'package:presyo/view/search.dart';
import 'package:presyo/view_model/product_viewmodel.dart';
import 'package:presyo/view_model/search_product_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SearchProductViewModel>(
            create: (context) => SearchProductViewModel()),
        ChangeNotifierProvider<ProductViewModel>(
            create: (context) => ProductViewModel())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.blue[900],
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          '/search': (BuildContext context) => Search(),
          '/addProduct': (BuildContext context) => AddProduct(),
          // '/editProduct': (BuildContext context) => EditProduct(product: null)
        },
        home: Search(),
      ),
    );
  }
}
