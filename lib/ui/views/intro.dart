import 'package:compound/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

import '../../constants/route_names.dart';
import '../../services/navigation_service.dart';

class IntroPage extends StatelessWidget {
  final Color backgroundColor = Colors.white;
  final double titleFontSize = 20;
  final double descriptionFontSize = 20;
  @override
  Widget build(BuildContext context) {
    return IntroSlider(
        slides: [
          Slide(
            description:
                "Discover Unique Home Grown Brands around you",
            marginDescription: EdgeInsets.only(left: 10, right: 10, top: 20),
            styleDescription: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: descriptionFontSize,
                color: Color.fromARGB(255, 62, 83, 119)),
            title: "Discover",
            marginTitle: EdgeInsets.only(top: 100),
            styleTitle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: titleFontSize,
                color: Color.fromARGB(255, 62, 83, 119)),
            pathImage: "assets/images/screen1.png",
            heightImage: 330,
            widthImage: 500,
            backgroundColor: backgroundColor,
          ),
          Slide(
              description:
                  "Get Unique and Special products delivered Home",
              marginDescription: EdgeInsets.only(left: 10, right: 10, top: 20),
              marginTitle: EdgeInsets.only(top: 100),
              styleDescription: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: titleFontSize,
                  color: Color.fromARGB(255, 62, 83, 119)),
              title: "Shop",
              styleTitle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: titleFontSize,
                  color: Color.fromARGB(255, 62, 83, 119)),
              pathImage: "assets/images/screen2.png",
              heightImage: 330,
              backgroundColor: backgroundColor),
          Slide(
              description:
                  "Book appointments with designers that fit your needs.",
              marginDescription: EdgeInsets.only(left: 10, right: 10, top: 20),
              styleDescription: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: titleFontSize,
                  color: Color.fromARGB(255, 62, 83, 119)),
              marginTitle: EdgeInsets.only(top: 100),
              title: "Collaborate",
              styleTitle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: titleFontSize,
                  color: Color.fromARGB(255, 62, 83, 119)),
              pathImage: "assets/images/screen3.png",
              heightImage: 330,
              backgroundColor: backgroundColor),
        ],
        onDonePress: this.onDonePress,
        onSkipPress: this.onSkipPress,
        colorDot: Colors.black,
        colorActiveDot: logoRed,
        doneButtonStyle: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              logoRed),
        ),
        skipButtonStyle: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              logoRed),
        ));
    // colorDoneBtn: Color.fromARGB(255, 235, 105, 105),
    // colorSkipBtn: Color.fromARGB(255, 235, 105, 105));
  }

  void onDonePress() => NavigationService.to(LoginViewRoute);

  void onSkipPress() => NavigationService.to(LoginViewRoute);
}
