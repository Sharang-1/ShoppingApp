// import 'dart:math';

import 'package:compound/models/promotions.dart';
import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/shared_styles.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/views/promotion_recieved_screen.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'custom_text.dart';

class AllConfettiWidget extends StatefulWidget {
  final Widget child;

  const AllConfettiWidget({
    required this.child,
    Key? key,
  }) : super(key: key);
  @override
  _AllConfettiWidgetState createState() => _AllConfettiWidgetState();
}

class _AllConfettiWidgetState extends State<AllConfettiWidget> {
  late ConfettiController controller;
  bool isPromotionWon = false;

  @override
  void initState() {
    super.initState();
    checkPromotion();
  }

  checkPromotion() async {
    final prefs = await SharedPreferences.getInstance();

    int? counter = prefs.getInt('promotion_product_share');
    bool? isPromotionActive = prefs.getBool('promotion_won');
    if (isPromotionActive ?? false) {
      setState(() {
        isPromotionWon = true;
        controller = ConfettiController(duration: Duration(seconds: 5));
        controller.play();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setInt("promotion_product_share", 0);
            await prefs.setBool('promotion_won', false);
            setState(() {
            controller.stop();
              isPromotionWon = false;
            });
            // if (controller.state == ConfettiControllerState.playing) {
            //   controller.stop();
            // } else {
            //   controller.play();
            // }
          },
          child: Stack(
            children: [
              widget.child,
              if (isPromotionWon) showPromotionDialog(),
              if (isPromotionWon) buildConfetti(),
            ],
          ),
        ),
      ),
    );
  }

  Widget showPromotionDialog() => Align(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.all(10),
          height: 400,
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(curve15),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Row()
              Text(
                "Thanks for sharing !",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: logoRed),
              ),
              Lottie.asset('assets/icons/ruffle-gift.json'),
              verticalSpaceSmall,
              Text(
                "You have a chance to win a product for free. Keep Sharing!",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
              ),
              verticalSpaceSmall,
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: lightGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => PromotionScreen()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: CustomText(
                      "View Product",
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildConfetti() => Align(
        alignment: Alignment.topCenter,
        child: ConfettiWidget(
          confettiController: controller,
          colors: const [
            Colors.red,
            Colors.blue,
            Colors.orange,
            Colors.purple,
            Colors.lightBlue,
          ],
          //blastDirection: blastDirection,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          emissionFrequency: 0.05,
          numberOfParticles: 5,
          gravity: 0.1,
          maxBlastForce: 10,
          minBlastForce: 1,
          particleDrag: 0.1,
        ),
      );
}
