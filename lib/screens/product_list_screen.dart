import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar:  CustomAppBar(title: "PRODUCT LIST"),
      body: Center(
        child: Text('ProductListScreen'),
      ),
    );
  }
}
