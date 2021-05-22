// import 'package:compound/ui/shared/app_colors.dart';
// import 'package:compound/viewmodels/pay_through_card_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_credit_card/credit_card_widget.dart';
// import 'package:flutter_credit_card/flutter_credit_card.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:provider_architecture/provider_architecture.dart';

// class PayThroughCard extends StatefulWidget {
//   PayThroughCard({Key key}) : super(key: key);

//   @override
//   _PayThroughCardState createState() => _PayThroughCardState();
// }

// class _PayThroughCardState extends State<PayThroughCard> {
//   String cardNumber = '', expiryDate = '', cardHolderName = '', cvvCode = '';
//   bool isCvvFocused = false;
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   void onCreditCardModelChange(CreditCardModel creditCardModel) {
//     setState(() {
//       cardNumber = creditCardModel.cardNumber;
//       expiryDate = creditCardModel.expiryDate;
//       cardHolderName = creditCardModel.cardHolderName;
//       cvvCode = creditCardModel.cvvCode;
//       isCvvFocused = creditCardModel.isCvvFocused;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ViewModelProvider<PayThroughCardViewModel>.withConsumer(
//       viewModel: PayThroughCardViewModel(),
//       builder: (context, model, child) => Scaffold(
//         resizeToAvoidBottomInset: true,
//         backgroundColor: backgroundWhiteCreamColor,
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: backgroundWhiteCreamColor,
//           centerTitle: true,
//           title: SvgPicture.asset(
//             "assets/svg/logo.svg",
//             color: logoRed,
//             height: 35,
//             width: 35,
//           ),
//           iconTheme: IconThemeData(
//             color: appBarIconColor,
//           ),
//         ),
//         body: SafeArea(
//           child: Column(
//             children: [
//               CreditCardWidget(
//                 cardNumber: cardNumber,
//                 expiryDate: expiryDate,
//                 cardHolderName: cardHolderName,
//                 cvvCode: cvvCode,
//                 showBackView: isCvvFocused,
//                 obscureCardNumber: true,
//                 obscureCardCvv: true,
//               ),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       CreditCardForm(
//                         formKey: formKey,
//                         cvvCode: cvvCode,
//                         cardNumber: cardNumber,
//                         expiryDate: expiryDate,
//                         cardHolderName: cardHolderName,
//                         onCreditCardModelChange: (creditCardModel) =>
//                             onCreditCardModelChange(
//                                 creditCardModel), // Required
//                         themeColor: Colors.red,
//                         obscureCvv: true,
//                         obscureNumber: true,
//                         cardNumberDecoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           labelText: 'Number',
//                           hintText: 'XXXX XXXX XXXX XXXX',
//                         ),
//                         expiryDateDecoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           labelText: 'Expiry Date',
//                           hintText: 'XX/XX',
//                         ),
//                         cvvCodeDecoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           labelText: 'CVV',
//                           hintText: 'XXX',
//                         ),
//                         cardHolderDecoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           labelText: 'Card Holder',
//                         ),
//                       ),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                           primary: const Color(0xff1b447b),
//                         ),
//                         child: Container(
//                           margin: const EdgeInsets.all(8),
//                           child: const Text(
//                             'Validate',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontFamily: 'halter',
//                               fontSize: 14,
//                               package: 'flutter_credit_card',
//                             ),
//                           ),
//                         ),
//                         onPressed: () {
//                           if (formKey.currentState.validate()) {
//                             print('valid!');
//                           } else {
//                             print('invalid!');
//                           }
//                         },
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
