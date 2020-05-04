import 'package:compound/locator.dart';
import 'package:compound/models/products.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/widgets/network_image_with_placeholder.dart';
import 'package:compound/ui/widgets/reviews.dart';
import 'package:compound/viewmodels/product_individual_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import '../shared/app_colors.dart';
import '../views/home_view_slider.dart';

class ProductIndiView extends StatefulWidget {
  final Product data;
  const ProductIndiView({Key key, @required this.data}) : super(key: key);
  @override
  _ProductIndiViewState createState() => _ProductIndiViewState();
}

class _ProductIndiViewState extends State<ProductIndiView> {
  String getTruncatedString(int length, String str) {
    return str.length <= length ? str : '${str.substring(0, length)}...';
  }

  Widget productNameAndDescInfo(productName,variations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          productName,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 2,
        ),
        Text(
          "By Anita's Creation",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget priceInfo(productPrice,productDiscount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              'Rs.${productPrice.toString()}',
              style: TextStyle(fontSize: 22, color: lightGrey),
            ),
            SizedBox(
              width: 5,
            ),
            SizedBox(width: 10),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: logoRed),
              child: Text(
                'SALE ${productDiscount.toString()}%',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        Text(
          'Rs.${(productPrice / (1 - (productDiscount / 100))).toString()}',
          style: TextStyle(
              color: Colors.grey,
              fontSize: 18,
              decoration: TextDecoration.lineThrough),
        ),
      ],
    );
  }

  List<Widget> allSizes(sizes) {
    List<Widget> allSizes = [];
    for (var item in sizes) {
      allSizes.add(Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
            color: textIconBlue, borderRadius: BorderRadius.circular(30)),
        child: Text(
          item,
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ));
      allSizes.add(horizontalSpaceTiny);
    }
    return allSizes;
  }

  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  List<Widget> allColors(colors) {
    List<Widget> allColors = [];
    for (var item in colors) {
      allColors.add(Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: _colorFromHex(item),
              borderRadius: BorderRadius.circular(30))));
      allColors.add(horizontalSpaceTiny);
    }
    return allColors;
  }

  Widget allTags(tags) {
    var alltags = "";
    for (var item in tags) {
      alltags += "#" + item + "  ";
    }
    return Text(
      alltags,
      textAlign: TextAlign.justify,
      style: TextStyle(fontSize: 18),
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

  Widget paddingWidget(Widget item) {
    return Padding(child: item, padding: EdgeInsets.fromLTRB(0, 10, 0, 0));
  }

  Widget tableLeftText(String item) {
    return paddingWidget(Text(
      item,
      style: TextStyle(color: Colors.grey, fontSize: 15),
    ));
  }

  Widget tableRightText(String item) {
    return paddingWidget(Text(
      item,
      style: TextStyle(fontSize: 15),
    ));
  }

  Widget otherDetails() {
    return Column(
      children: <Widget>[
        Table(
          children: [
            TableRow(children: [
              Text(
                "Product Details",
                style: TextStyle(fontSize: 17),
              ),
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

  Widget bottomBar(ProductIndividualViewModel model) {
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
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500),
          )),
        ),
        GestureDetector(
          onTap: () {
            model.addToCart(widget.data, 1, "1");
          },
          child: Container(
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
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final String originalPhotoName =
        'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80';
    final String productName = widget.data.name ?? "Iphone 11";
    final String productId = widget.data.key;
    final double productDiscount = widget.data.discount ?? 0.0;
    final double productPrice = widget.data.price ?? 0.0;
    final double productOldPrice = widget.data.oldPrice ?? 0.0;
    final productRatingObj = widget.data.rating ?? null;
    final tags = ["JustHere", "Trending"];
    final productRatingValue =
        productRatingObj != null ? productRatingObj.rate : 0.0;
    final bool available = widget.data.available ?? false;
    final sizes = ["L", "M", "XL", "XXL"];
    final colors = ["#3e5377", "#eb6969", "#78a2ec", "#7062b1"];
    int selectedQty = 0;

    return ViewModelProvider<ProductIndividualViewModel>.withConsumer(
      viewModel: ProductIndividualViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundWhiteCreamColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: backgroundWhiteCreamColor,
          iconTheme: IconThemeData(color: textIconBlue),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.shopping_cart,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                productNameAndDescInfo(productName,widget.data.variations),
                SizedBox(
                  height: 10,
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: HomeSlider())),
                verticalSpace(15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(child: priceInfo(productPrice,productDiscount)),
                    Icon(
                      Icons.favorite_border,
                      color: darkRedSmooth,
                      size: 30,
                    ),
                  ],
                ),

                verticalSpace(10),
                allTags(tags),
                verticalSpace(20),
                Row(
                  children: <Widget>[
                    Text(
                      "Availability : ",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    available
                        ? Text(
                            "In Stock",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          )
                        : Text("Out Of Stock",
                            style: TextStyle(
                              fontSize: 15,
                            )),
                  ],
                ),
                verticalSpace(5),
                Row(
                  children: <Widget>[
                    Text(
                      "Delivery In :",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    horizontalSpaceSmall,
                    Text(
                      "2 Days",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                verticalSpace(5),
                Row(
                  children: <Widget>[
                    Text(
                      "Delivery To :",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    horizontalSpaceSmall,
                    Expanded(
                        child: Text(
                      "Add ur address here   kkk kkk   ",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    )),
                  ],
                ),
                verticalSpace(20),
                Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Select Size",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          verticalSpace(5),
                          Row(
                            children: allSizes(sizes),
                          ),
                          verticalSpace(20),
                          Row(
                            children: <Widget>[
                              Text(
                                "Select Qty",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              horizontalSpaceTiny,
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: textIconBlue,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                        "+",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 30),
                                      ),
                                    ),
                                    horizontalSpaceSmall,
                                    Text(
                                      selectedQty.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    horizontalSpaceSmall,
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                        "-",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 30),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          verticalSpace(20),
                          Text(
                            "Select Color",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          verticalSpace(5),
                          Row(
                            children: allColors(colors),
                          ),
                        ],
                      ),
                    )),
                verticalSpace(20),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: textIconOrange,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Text(
                        "BUY NOW",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                verticalSpace(10),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: logoRed,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Text(
                        "ADD TO CART",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                verticalSpace(20),
                Text(
                  "Description",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                verticalSpace(5),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: Container(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        widget.data.description,
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      )),
                )

                // SizedBox(
                //   height: 20,
                // ),
                // rattingsInfo(),
                // SizedBox(
                //   height: 40,
                // ),
                // otherDetails(),
                // verticalSpaceMedium,
                // ReviewWidget(productId),
                // verticalSpaceMedium,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
