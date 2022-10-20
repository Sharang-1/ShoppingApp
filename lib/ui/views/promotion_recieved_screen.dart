import 'dart:convert';

import 'package:compound/models/cart.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/app.dart';

class PromotionScreen extends StatefulWidget {
  const PromotionScreen({Key? key}) : super(key: key);

  @override
  State<PromotionScreen> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  String? promotedProduct;
  Product _productInfo = Product();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPromotedProduct();
  }

  getPromotedProduct() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
    promotedProduct = prefs.getString('promoted_product');
      
    });
    print("hehehe ${promotedProduct.toString()}");

    // if (promotedProduct != null) {
    //   _productInfo = APIService().getProductById(productId: promotedProduct!);
    //   print("voila ${_productInfo.name}");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            child: Text(promotedProduct.toString()),
            ),
      ),
    );
  }
}
