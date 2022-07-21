import 'package:flutter/material.dart';

const Color lightGrey = Color.fromARGB(255, 61, 63, 69);
const Color darkGrey = Color.fromARGB(255, 18, 18, 19);
// const Color primaryColor = Color.fromARGB(255,61,63,69);//Color.fromARGB(255, 9, 202, 172);

Color primaryColor = _colorFromHex("#3e5377"); //_colorFromHex("#7062b1");
Color secondaryColor = _colorFromHex("#bE505F"); //  _colorFromHex("#e1547e");

Color lightRedSmooth = _colorFromHex("#f57f8d");
// Color darkRedSmooth = _colorFromHex("#bE505F"); //_colorFromHex("#e1547e");
Color darkRedSmooth = logoRed;
// Color logoRed = _colorFromHex("#F2AO4E");
Color lightBlue = _colorFromHex("#78a2ec");
Color logoRed = Color(0xFFF2A04E);
Color green = Colors.green[700]!;
Color lightGreen = _colorFromHex("#51BF47");
Color textIconOrange = _colorFromHex("#eb6969");
Color textIconBlue = _colorFromHex("#3e5377");
Color cityTextBlueColor = Colors.blue[900]!;
Color appBarIconColor = Colors.black;

const Color backgroundColor = Color.fromARGB(255, 26, 27, 30);
Color backgroundWhiteCreamColor = _colorFromHex("#f5f0e5");
Color backgroundBlueGreyColor = _colorFromHex("#d6d9dD");
Color newBackgroundColor = Color.fromRGBO(255, 255, 255, 0.95);
Color newBackgroundColor2 = Color.fromRGBO(255, 255, 255, 1);

Color shimmerBaseColor = Colors.grey[300]!;
Color shimmerHighlightColor = Colors.grey[100]!;

Color _colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

const List<String> categoriesIndiBgColorsPallete = [
  "#f57f8d",
  "#e750b7",
  "#ac48dc",
  "#934bdd",
  "#7062b1",
  "#757af2",
  "#6d7fe5",
  "#78a2ec"
];
