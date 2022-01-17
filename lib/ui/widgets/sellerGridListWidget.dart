import 'package:flutter/material.dart';

class SellerGridListWidget extends StatelessWidget {
  const SellerGridListWidget({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 30,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 3,
          child: Container(
            alignment: Alignment.center,
            child: Text('Seller $index'),
          ),
        );
      },
    );
  }
}
