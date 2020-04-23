import 'package:compound/models/products.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:compound/viewmodels/product_individual_view_model.dart';

class ProductIndividualView extends StatelessWidget {
  final Product data;

  const ProductIndividualView({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ProductIndividualViewModel>.withConsumer(
      viewModel: ProductIndividualViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(data.name),
              ],
            ),
          )),
    );
  }
}
