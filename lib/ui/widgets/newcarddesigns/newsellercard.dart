import 'package:flutter/material.dart';

class RestaurantListItem2 extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String description;
  final double ratting;
  final int mins;
  final int price;

  RestaurantListItem2(
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
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Card(
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
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 100.0,
                  height: 130.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/placeholder.png')),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    color: Colors.redAccent,
                  ),
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
                              fontSize: 15,
                              color: Color(0xff3d4152),
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(description,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xff7e808c),
                            fontWeight: FontWeight.w600,
                          )),
                      Divider(
                        indent: 11,
                        endIndent: 15,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "Ready Made Garments, Kurtas, Kurtis",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff7e808c),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "Stiching Services offered",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff7e808c),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[],
                        ),
                      )
                    ],
                  ),
                ),
              )
              // food info end
            ],
          ),
        ),
      ),
    );
  }
}

// Widget restaurantListItem2({
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
//         padding: const EdgeInsets.only(bottom: 8.0),
//         child: Card(
//           margin: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15.0),
//           ),
//           color: Colors.white,
//           elevation: 6,
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               // food image container start
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   width: 100.0,
//                   height: 130.0,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                         fit: BoxFit.cover,
//                         image: AssetImage('assets/images/placeholder.png')),
//                     borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                     color: Colors.redAccent,
//                   ),
//                 ),
//               ),
//               // food image container end

//               // food info start
//               Expanded(
//                 child: Container(
//                   margin: EdgeInsets.only(left: 15, top: 6),
//                   width: double.infinity,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Container(
//                         child: Text(name,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               fontSize: 15,
//                               color: Color(0xff3d4152),
//                               fontWeight: FontWeight.w600,
//                             )),
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Text(description,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: Color(0xff7e808c),
//                             fontWeight: FontWeight.w600,
//                           )),
//                       Divider(
//                         indent: 11,
//                         endIndent: 15,
//                       ),
//                       Container(
//                         padding: EdgeInsets.symmetric(vertical: 5),
//                         child: Text(
//                           "Ready Made Garments, Kurtas, Kurtis",
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Color(0xff7e808c),
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         padding: EdgeInsets.symmetric(vertical: 5),
//                         child: Text(
//                           "Stiching Services offered",
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Color(0xff7e808c),
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         child: Row(
//                           children: <Widget>[],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               )
//               // food info end
//             ],
//           ),
//         ),
//       ),
//     );
