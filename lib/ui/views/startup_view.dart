import 'package:compound/viewmodels/startup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../shared/app_colors.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<StartUpViewModel>.withConsumer(
      viewModel: StartUpViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
          backgroundColor: backgroundWhiteCreamColor,
          body: Center(
            child: SvgPicture.asset(
              "assets/svg/DZOR_full_logo_verti.svg",
              color: logoRed,
              width: MediaQuery.of(context).size.width / 2,
            ),
          )),
    );
  }
}

// class StartUpView extends StatelessWidget {
//   const StartUpView({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ViewModelProvider<StartUpViewModel>.withConsumer(
//       viewModel: StartUpViewModel(),
//       onModelReady: (model) => model.init(),
//       builder: (context, model, child) => Scaffold(
//         backgroundColor: Colors.white,
//         body: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 SizedBox(
//                   width: 300,
//                   height: 100,
//                   child: AppTitle()
//                 ),
//                 SizedBox(
//                   height: 50,
//                 ),
//                 CircularProgressIndicator(
//                   strokeWidth: 3,
//                   valueColor: AlwaysStoppedAnimation(
//                     Theme.of(context).primaryColor,
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
