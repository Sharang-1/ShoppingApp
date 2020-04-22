// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'styles.dart';

// class FormPage extends StatelessWidget {
//   static Map<String, String> formState = {};

//   final List<Widget> children;
//   final double pageSizeProportion;
//   final GlobalKey<FormState> formKey;
//   final String title;
//   final bool isHidden;

//   const FormPage({
//     Key key,
//     this.title = '',
//     this.formKey,
//     this.isHidden = false,
//     @required this.pageSizeProportion,
//     @required this.children,
//   }) : super(key: key);

//   // Size screenSize;
//   // double bottomPosition;
//   // double startPosition;
//   // double topListPadding = 0;

//   @override
//   Widget build(BuildContext context) {
//     Size screenSize = MediaQuery.of(context).size;
//     return Stack(
//       children: <Widget>[
//         if (!isHidden)
//           Align(
//             alignment: Alignment.topCenter,
//             child: GestureDetector(
//               onTap: () => _handleBackGesture(context),
//               child: Container(
//                 width: double.infinity,
//                 height: screenSize.height * (1 - pageSizeProportion),
//                 color: Colors.transparent,
//               ),
//             ),
//           ),
//         Align(
//           alignment: Alignment.bottomCenter,
//           child: GestureDetector(
//             onTap: () => _handleTap(context),
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 37)
//                   .add(EdgeInsets.only(top: 18)),
//               width: screenSize.width,
//               height: screenSize.height * pageSizeProportion,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
//                 border: Border.all(color: Color(0xffd4d4d4)),
//                 borderRadius: BorderRadius.vertical(
//                   top: Radius.circular(20),
//                 ),
//               ),
//               child: Scaffold(
//                 backgroundColor: Colors.white,
//                 body: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: <Widget>[
//                       Text(title),//, style: Styles.formTitle),
//                       Expanded(
//                         child: Form(
//                           key: formKey,
//                           child: SingleChildScrollView(
//                             padding: EdgeInsets.symmetric(vertical: 20.0),
//                             physics: BouncingScrollPhysics(),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: children,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ]),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   _handleTap(BuildContext context) {
//     //To improve user experience, we'll unfocus any textfields when the users taps oon the background of the form
//     if (MediaQuery.of(context).viewInsets.bottom > 0)
//       SystemChannels.textInput.invokeMethod('TextInput.hide');
//     WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
//   }

//   _handleBackGesture(BuildContext context) {
//     if (Navigator.of(context).canPop()) Navigator.of(context).pop();
//   }
// }
