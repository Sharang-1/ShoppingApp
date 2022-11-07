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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            
            controller.stop();
            
          },
          child: Stack(
            children: [
              widget.child,
              // if (isPromotionWon) showPromotionDialog(),
              buildConfetti(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget showPromotionDialog() => Align(
  //       alignment: Alignment.center,
  //       child: Container(
  //         padding: EdgeInsets.all(10),
  //         height: 400,
  //         width: MediaQuery.of(context).size.width * 0.7,
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(curve15),
  //           boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
  //         ),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             // Row()
  //             Text(
  //               "Thanks for sharing !",
  //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: logoRed),
  //             ),
  //             Lottie.asset('assets/icons/ruffle-gift.json'),
  //             verticalSpaceSmall,
  //             Text(
  //               "You have a chance to win a product for free. Keep Sharing!",
  //               textAlign: TextAlign.center,
  //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
  //             ),
  //             verticalSpaceSmall,
  //             ElevatedButton(
  //               style: ElevatedButton.styleFrom(
  //                 elevation: 0,
  //                 primary: lightGreen,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //               ),
  //               onPressed: () {
  //                 Navigator.push(context, MaterialPageRoute(builder: (_) => PromotionScreen()));
  //               },
  //               child: Padding(
  //                 padding: const EdgeInsets.all(10),
  //                 child: Center(
  //                   child: CustomText(
  //                     "View Product",
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.white,
  //                     fontSize: 16,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );

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
