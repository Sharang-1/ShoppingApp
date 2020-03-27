import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Text("DZOR", style: TextStyle(color: Colors.white),),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }
}
