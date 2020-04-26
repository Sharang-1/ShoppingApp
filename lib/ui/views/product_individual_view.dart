import 'package:compound/models/products.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/widgets/network_image_with_placeholder.dart';
import 'package:compound/ui/widgets/reviews.dart';
import 'package:flutter/material.dart';
import '../shared/app_colors.dart';

class ProductIndiView extends StatelessWidget {
  final Product data;

  const ProductIndiView({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final photo = data.photo ?? null;
    // final photos = photo != null ? photo.photos ?? null : null;
    final String originalPhotoName =
        'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80';
    final String productName = data.name ?? "Iphone 11";
    final String productId = data.key;
    final double productDiscount = data.discount ?? 0.0;
    final double productPrice = data.price ?? 0.0;
    final double productOldPrice = data.oldPrice ?? 0.0;
    final productRatingObj = data.rating ?? null;
    final productRatingValue =
        productRatingObj != null ? productRatingObj.rate : 0.0;
    String getTruncatedString(int length, String str) {
      return str.length <= length ? str : '${str.substring(0, length)}...';
    }

    Widget productNameAndDescInfo() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            getTruncatedString(20, productName),
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "A style icon gets some love from one of today's top "
            "trendsetters. Pharrell Williams puts his creative spin on these "
            "shoes, which have all the clean, classicdetails of the beloved Stan Smith.",
            textAlign: TextAlign.justify,
            style: TextStyle(height: 1.5, color: Color(0xFF6F8398)),
          )
        ],
      );
    }

    Widget priceInfo() {
      return Row(
        children: <Widget>[
          Text(
            'Rs.${productPrice.toString()}',
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.w600, color: lightGrey),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'Rs.${productOldPrice.toString()}',
            style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.lineThrough),
          ),
          SizedBox(width: 10),
          Text(
            '${productDiscount.toString()}% Off',
            style: TextStyle(
                fontSize: 20,
                color: Colors.lightGreen,
                fontWeight: FontWeight.w600),
          ),
        ],
      );
    }

    Widget rattingsInfo() {
      return Row(
        children: <Widget>[
          Container(
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              color: Colors.lightGreen,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Row(
                children: <Widget>[
                  Text(
                    "3.5",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "1050 ratings",
            style: TextStyle(height: 1.5, color: Color(0xFF6F8398)),
          )
        ],
      );
    }

    Widget paddingWidget(Widget item){
      return Padding(child:item,padding: EdgeInsets.fromLTRB(0, 10, 0, 0));
    }
    Widget tableLeftText(String item){
      return paddingWidget(Text(item,style: TextStyle(color: Colors.grey,fontSize: 15),));
    }
    Widget tableRightText(String item){
      return paddingWidget(Text(item,style: TextStyle(fontSize: 15),));
    }

    Widget otherDetails() {
      return Column(
        children: <Widget>[
          Table(
            children: [
              TableRow(children: [
                Text("Product Details",style: TextStyle(fontSize: 17),),
                tableRightText(""), 
              ]),
               TableRow(children: [
                tableLeftText("color"),
                tableRightText("grey"), 
              ]),
               TableRow(children: [
                tableLeftText("Sizes"),
                tableRightText("X M L"), 
              ]),
               TableRow(children: [
                tableLeftText("Stiches"),
                tableRightText("multitype"), 
              ]),
            ],
          )
        ],
      );
    }

    Widget bottomBar() {
      return new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 2,
            height: 60,
            child: Center(
                child: Text(
              "ADD TO WISHLIST ",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w500),
            )),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2,
            height: 60,
            color: lightGrey,
            child: Center(
                child: Text(
              "ADD TO CART ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w500),
            )),
          )
        ],
      );
    }

    return Scaffold(
      bottomNavigationBar: new BottomAppBar(child: bottomBar()),
      appBar: AppBar(
        title: Text("Dzor"),
        leading: Icon(Icons.arrow_back),
        actions: <Widget>[
          Icon(Icons.search),
          SizedBox(
            width: 20,
          ),
          Icon(Icons.check_box),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: NetworkImageWithPlaceholder(
                          name: originalPhotoName))),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    productNameAndDescInfo(),
                    SizedBox(
                      height: 20,
                    ),
                    priceInfo(),
                    SizedBox(
                      height: 20,
                    ),
                    rattingsInfo(),
                    SizedBox(
                      height: 40,
                    ),
                    otherDetails(),
                    verticalSpaceMedium,
                    ReviewWidget(productId),
                    verticalSpaceMedium  
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Product page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Montserrat'),
      home: MyHomePage(title: 'Flutter Product page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selected = "blue";
  bool favourite = false;
  final String originalPhotoName =
      'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            hero(),
            spaceVertical(20),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "Iphone 11",
                style: TextStyle(fontSize: 30),
              ),
            ),
            Text('Rs.100'),
            SizedBox(
              width: 5.0,
            ),
            // if (productOldPrice != 0.0)
            Text(
              'Rs.2200',
              style: TextStyle(
                  color: Colors.grey, decoration: TextDecoration.lineThrough),
            ),
            // //Center Items
            // Expanded(
            //   child: sections(),
            // ),

            //   //Bottom Button
            // purchase()
          ],
        ),
      ),
    );
  }

  ///************** Hero   ***************************************************/

  Widget hero() {
    return Container(
      child: Stack(
        children: <Widget>[
          // Image.asset("images/shoe_$selected.png",), //This
          NetworkImageWithPlaceholder(name: originalPhotoName),
          // should be a paged
          // view.
          // Positioned(
          //   child: appBar(),
          //   top: 0,
          // ),
          Positioned(
            child: FloatingActionButton(
                elevation: 2,
                child: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                backgroundColor: Colors.white,
                onPressed: () {
                  setState(() {
                    favourite = !favourite;
                  });
                }),
            bottom: 10,
            right: 20,
          ),
        ],
      ),
    );
  }

  Widget appBar() {
    return Container(
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Image.asset("images/back_button.png"),
          Container(
            child: Column(
              children: <Widget>[
                Text(
                  "MEN'S ORIGINAL",
                  style: TextStyle(fontWeight: FontWeight.w100, fontSize: 14),
                ),
                Text(
                  "Smiths Shoes",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F2F3E)),
                ),
              ],
            ),
          ),
          // Image.asset("images/bag_button.png", width: 27, height: 30,),
        ],
      ),
    );
  }

  /***** End */

  ///************ SECTIONS  *************************************************/

  Widget sections() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          // description(),
          // spaceVertical(50),
          property(),
        ],
      ),
    );
  }

  Widget description() {
    return Text(
      "A style icon gets some love from one of today's top "
      "trendsetters. Pharrell Williams puts his creative spin on these "
      "shoes, which have all the clean, classicdetails of the beloved Stan Smith.",
      textAlign: TextAlign.justify,
      style: TextStyle(height: 1.5, color: Color(0xFF6F8398)),
    );
  }

  Widget property() {
    return Container(
      padding: EdgeInsets.only(right: 20, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "COLOR",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2F2F3E)),
              ),
              spaceVertical(10),
              // colorSelector(),
            ],
          ),
          size()
        ],
      ),
    );
  }

  Widget colorSelector() {
    return Container(
      child: Row(
        children: <Widget>[
          ColorTicker(
            color: Colors.blue,
          ),
          ColorTicker(
            color: Colors.green,
          ),
          // ColorTicker(
          //   color: Colors.yellow,
          //   selected: selected == "yellow",
          //   selectedCallback: () {
          //     setState(() {
          //       selected = "yellow";
          //     });
          //   },
          // ),
          // ColorTicker(
          //   color: Colors.pink,
          //   selected: selected == "pink",
          //   selectedCallback: () {
          //     setState(() {
          //       selected = "pink";
          //     });
          //   },
          // ),
        ],
      ),
    );
  }

  Widget size() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Size",
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2F2F3E)),
        ),
        spaceVertical(10),
        Container(
          width: 70,
          padding: EdgeInsets.all(10),
          color: Color(0xFFF5F8FB),
          child: Text(
            "10.1",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F2F3E)),
          ),
        )
      ],
    );
  }

  /***** End */

  ///************** BOTTOM BUTTON ********************************************/
  Widget purchase() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            child: Text(
              "ADD TO BAG +",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2F2F3E)),
            ),
            color: Colors.transparent,
            onPressed: () {},
          ),
          Text(
            r"$95",
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w100,
                color: Color(0xFF2F2F3E)),
          )
        ],
      ),
    );
  }

  /***** End */

  ///************** UTILITY WIDGET ********************************************/

  Widget spaceVertical(double size) {
    return SizedBox(
      height: size,
    );
  }

  Widget spaceHorizontal(double size) {
    return SizedBox(
      width: size,
    );
  }
  /***** End */
}

class ColorTicker extends StatelessWidget {
  final Color color;
  final bool selected;
  final VoidCallback selectedCallback;
  ColorTicker({this.color, this.selected, this.selectedCallback});

  @override
  Widget build(BuildContext context) {
    print(selected);
    return GestureDetector(
        onTap: () {
          selectedCallback();
        },
        child: Container(
          padding: EdgeInsets.all(7),
          margin: EdgeInsets.all(5),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: color.withOpacity(0.7)),
          child: selected ? Image.asset("images/checker.png") : Container(),
        ));
  }
}
