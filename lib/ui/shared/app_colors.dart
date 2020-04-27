import 'package:flutter/material.dart';

const Color lightGrey = Color.fromARGB(255,61,63,69);
const Color darkGrey = Color.fromARGB(255,18,18,19);
// const Color primaryColor = Color.fromARGB(255,61,63,69);//Color.fromARGB(255, 9, 202, 172);
Color primaryColor = _colorFromHex("#7062b1");
Color secondaryColor =  _colorFromHex("#e1547e");
Color lightRedSmooth =  _colorFromHex("#f57f8d");
Color darkRedSmooth =  _colorFromHex("#e1547e");
Color lightBlue =  _colorFromHex("#78a2ec");
const Color backgroundColor = Color.fromARGB(255, 26, 27, 30);

Color _colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}