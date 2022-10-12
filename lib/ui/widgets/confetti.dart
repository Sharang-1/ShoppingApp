import 'dart:math';

import 'package:compound/ui/shared/shared_styles.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

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

    controller = ConfettiController(duration: Duration(seconds: 5));
    controller.play();
  }

  static final double right = 0;
  static final double down = pi / 2;
  static final double left = pi;
  static final double top = -pi / 2;

  final double blastDirection = left;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            controller.stop();
            setState(() {
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
              if(isPromotionWon)showPromotionDialog(),
              if(isPromotionWon)buildConfetti(),
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
          height: 150,
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
              Text("You have a chance to win a product for free"),
              Text("Tap to dismiss!"),
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
