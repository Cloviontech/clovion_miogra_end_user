
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miogra/features/profile/pages/wishlist.dart';

import '../widgets/order_widgets.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        leading: IconButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const WishList(),));
        }, icon: const Icon(Icons.arrow_back,color: Colors.white,size: 30,)),
        title: const Text('Order',style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          orderList(context)
        ],
      ),
    );
  }
}
