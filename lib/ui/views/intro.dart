import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:compound/constants/route_names.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
          description:
              "Discover traditional wear designers with unique philosophies around you.",
          marginDescription: EdgeInsets.only(left: 10, right: 10, top: 20),
          styleDescription: TextStyle(
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color.fromARGB(255, 62, 83, 119)),
          title: "Discover",
          marginTitle: EdgeInsets.only(top: 100),
          styleTitle: TextStyle(
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Color.fromARGB(255, 62, 83, 119)),
          pathImage: "assets/images/screen1.png",
          heightImage: 330,
          widthImage: 500,
          backgroundColor: Color.fromARGB(255, 245, 240, 229)),
    );
    slides.add(
      new Slide(
          description:
              " Get authentic regional traditional wear delivered home.",
          marginDescription: EdgeInsets.only(left: 10, right: 10, top: 20),
          marginTitle: EdgeInsets.only(top: 100),
          styleDescription: TextStyle(
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color.fromARGB(255, 62, 83, 119)),
          title: "Shop",
          styleTitle: TextStyle(
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Color.fromARGB(255, 62, 83, 119)),
          pathImage: "assets/images/screen2.png",
          heightImage: 330,
          backgroundColor: Color.fromARGB(255, 245, 240, 229)),
    );
    slides.add(
      new Slide(
          description: "Book appointments with designers that fit your needs.",
          marginDescription: EdgeInsets.only(left: 10, right: 10, top: 20),
          styleDescription: TextStyle(
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color.fromARGB(255, 62, 83, 119)),
          marginTitle: EdgeInsets.only(top: 100),
          title: "Collaborate",
          styleTitle: TextStyle(
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Color.fromARGB(255, 62, 83, 119)),
          pathImage: "assets/images/screen3.png",
          heightImage: 330,
          backgroundColor: Color.fromARGB(255, 245, 240, 229)),
    );
  }

  void onDonePress() {
    Navigator.pushNamed(context, LoginViewRoute);
  }

  void onSkipPress() {
    Navigator.pushNamed(context, LoginViewRoute);
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
        slides: this.slides,
        onDonePress: this.onDonePress,
        onSkipPress: this.onSkipPress,
        colorDot: Colors.black,
        colorActiveDot: Color.fromARGB(255, 235, 105, 105),
        colorDoneBtn: Color.fromARGB(255, 235, 105, 105),
        colorSkipBtn: Color.fromARGB(255, 235, 105, 105));
  }
}
