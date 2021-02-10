import 'package:flutter/material.dart';
import 'package:compound/ui/shared/app_colors.dart';

class RestaurantListItem3 extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String description;
  final double ratting;
  final int mins;
  final int price;

  RestaurantListItem3(
      {this.imageUrl,
      this.name,
      this.description,
      this.ratting,
      this.mins,
      this.price});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: Padding(
        padding: const EdgeInsets.only(left: 5, bottom: 8.0, right: 5),
        child: Stack(
          children: [
            Card(
              margin: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.white,
              elevation: 6,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // food image container start
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Stack(
                      children: [
                        Container(
                          width: 140.0,
                          height: 145.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    'assets/images/product_preloading.png')),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(10)),
                            color: Colors.redAccent,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0, top: 0),
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(16),
                                  ),
                                  color: textIconOrange),
                              width: 40,
                              height: 30,
                              child: Center(
                                  child: Text(
                                "10%",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ))),
                        )
                      ],
                    ),
                  ),
                  // food image container end

                  // food info start
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 15, top: 6),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Text(name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xff3d4152),
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          //Text(description,
                          //   overflow: TextOverflow.ellipsis,
                          //   style: TextStyle(
                          //    fontSize: 13,
                          //  color: Color(0xff7e808c),
                          //fontWeight: FontWeight.w600,
                          // )),
                          Divider(
                            indent: 11,
                            endIndent: 15,
                          ),
                          // Container(
                          //   padding: EdgeInsets.symmetric(vertical: 5),
                          //   child: Text(
                          //     "Ready Made Garments, Kurtas, Kurtis",
                          //     style: TextStyle(
                          //       fontSize: 12,
                          //       color: Color(0xff7e808c),
                          //       fontWeight: FontWeight.w500,
                          //     ),
                          //   ),
                          // ),
                          // Container(
                          //   padding: EdgeInsets.symmetric(vertical: 5),
                          //   child: Text(
                          //     "Stiching Services offered",
                          //     style: TextStyle(
                          //       fontSize: 12,
                          //       color: Color(0xff7e808c),
                          //       fontWeight: FontWeight.w500,
                          //     ),
                          //   ),
                          // ),
                          Row(
                            children: [
                              Container(
                                  child: Text(
                                "₹ 1000",
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey[500],
                                    fontSize: 13),
                              )),
                              SizedBox(
                                width: 7,
                              ),
                              Container(
                                  child: Text(
                                "₹ 900",
                                style: TextStyle(
                                    color: Color.fromARGB(240, 87, 86, 84),
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              )),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Text(
                                "Qty: ",
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(
                                width: 35,
                              ),
                              Text(
                                "1 ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(240, 87, 86, 84)),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Text(
                                "Size: ",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Text("M",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(240, 87, 86, 84))),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                  // food info end
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 306.0, top: 129),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomRight: Radius.circular(15),
                    ),
                    color: Color.fromARGB(200, 235, 105, 105),
                  ),
                  width: 34,
                  height: 33,
                  child: Image.asset(
                    "assets/images/cancel.png",
                    height: 18,
                    width: 11,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

// Widget restaurantListItem3({
//   String imageUrl,
//   String name,
//   String description,
//   double ratting,
//   int mins,
//   int price,
// }) =>
//     Container(
//       height: 180,
//       margin: EdgeInsets.only(top: 20, bottom: 20),
//       child: Padding(
//         padding: const EdgeInsets.only(left: 5, bottom: 8.0, right: 5),
//         child: Stack(
//           children: [
//             Card(
//               margin: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15.0),
//               ),
//               color: Colors.white,
//               elevation: 6,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   // food image container start
//                   Padding(
//                     padding: const EdgeInsets.all(0.0),
//                     child: Stack(
//                       children: [
//                         Container(
//                           width: 140.0,
//                           height: 145.0,
//                           decoration: BoxDecoration(
//                             image: DecorationImage(
//                                 fit: BoxFit.cover,
//                                 image: AssetImage(
//                                     'assets/images/placeholder.png')),
//                             borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(8),
//                                 bottomLeft: Radius.circular(10)),
//                             color: Colors.redAccent,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 0.0, top: 0),
//                           child: Container(
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.only(
//                                     topLeft: Radius.circular(8),
//                                     bottomRight: Radius.circular(16),
//                                   ),
//                                   color: textIconOrange),
//                               width: 40,
//                               height: 30,
//                               child: Center(
//                                   child: Text(
//                                 "10%",
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold),
//                               ))),
//                         )
//                       ],
//                     ),
//                   ),
//                   // food image container end

//                   // food info start
//                   Expanded(
//                     child: Container(
//                       margin: EdgeInsets.only(left: 15, top: 6),
//                       width: double.infinity,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Container(
//                             child: Text(name,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   color: Color(0xff3d4152),
//                                   fontWeight: FontWeight.w600,
//                                 )),
//                           ),
//                           SizedBox(
//                             height: 5,
//                           ),
//                           //Text(description,
//                           //   overflow: TextOverflow.ellipsis,
//                           //   style: TextStyle(
//                           //    fontSize: 13,
//                           //  color: Color(0xff7e808c),
//                           //fontWeight: FontWeight.w600,
//                           // )),
//                           Divider(
//                             indent: 11,
//                             endIndent: 15,
//                           ),
//                           // Container(
//                           //   padding: EdgeInsets.symmetric(vertical: 5),
//                           //   child: Text(
//                           //     "Ready Made Garments, Kurtas, Kurtis",
//                           //     style: TextStyle(
//                           //       fontSize: 12,
//                           //       color: Color(0xff7e808c),
//                           //       fontWeight: FontWeight.w500,
//                           //     ),
//                           //   ),
//                           // ),
//                           // Container(
//                           //   padding: EdgeInsets.symmetric(vertical: 5),
//                           //   child: Text(
//                           //     "Stiching Services offered",
//                           //     style: TextStyle(
//                           //       fontSize: 12,
//                           //       color: Color(0xff7e808c),
//                           //       fontWeight: FontWeight.w500,
//                           //     ),
//                           //   ),
//                           // ),
//                           Row(
//                             children: [
//                               Container(
//                                   child: Text(
//                                 "₹ 1000",
//                                 style: TextStyle(
//                                     decoration: TextDecoration.lineThrough,
//                                     color: Colors.grey[500],
//                                     fontSize: 13),
//                               )),
//                               SizedBox(
//                                 width: 7,
//                               ),
//                               Container(
//                                   child: Text(
//                                 "₹ 900",
//                                 style: TextStyle(
//                                     color: Color.fromARGB(240, 87, 86, 84),
//                                     fontSize: 17,
//                                     fontWeight: FontWeight.bold),
//                               )),
//                             ],
//                           ),
//                           SizedBox(height: 10),
//                           Row(
//                             children: <Widget>[
//                               Text(
//                                 "Qty: ",
//                                 style: TextStyle(color: Colors.grey),
//                               ),
//                               SizedBox(
//                                 width: 35,
//                               ),
//                               Text(
//                                 "1 ",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Color.fromARGB(240, 87, 86, 84)),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 10),
//                           Row(
//                             children: <Widget>[
//                               Text(
//                                 "Size: ",
//                                 style:
//                                     TextStyle(fontSize: 14, color: Colors.grey),
//                               ),
//                               SizedBox(
//                                 width: 30,
//                               ),
//                               Text("M",
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold,
//                                       color: Color.fromARGB(240, 87, 86, 84))),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   )
//                   // food info end
//                 ],
//               ),
//             ),
//             Padding(
//                 padding: const EdgeInsets.only(left: 306.0, top: 129),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(8),
//                       bottomRight: Radius.circular(15),
//                     ),
//                     color: Color.fromARGB(200, 235, 105, 105),
//                   ),
//                   width: 34,
//                   height: 33,
//                   child: Image.asset(
//                     "assets/images/cancel.png",
//                     height: 18,
//                     width: 11,
//                   ),
//                 ))
//           ],
//         ),
//       ),
//     );
