import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
       appBar: CustomAppBar(title: "ORDER HISTORY"),
      body: Center(
        child: Text('OrderHistoryScreen'),
      ),
    );
  }
}
