import 'package:flutter/material.dart';

import 'product_app.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quản lý sản phẩm',
      home: ProductApp(),
    );
  }
}
