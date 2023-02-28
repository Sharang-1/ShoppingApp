// import 'package:cached_network_image/cached_network_image.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:compound/models/products.dart';
import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/server_urls.dart';
import '../../controllers/base_controller.dart';
import '../../services/navigation_service.dart';
import '../widgets/custom_text.dart';
import '../widgets/date_count_down.dart';

class PromotionScreen extends StatefulWidget {
  final Product? data;
  const PromotionScreen({Key? key, this.data}) : super(key: key);

  @override
  State<PromotionScreen> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  // String? promotedProduct;
  // Product _productInfo = Product();
  // Product? data;
  @override
  void initState() {
    super.initState();
    FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 15));
  }

  // getPromotedProduct() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     promotedProduct = prefs.getString('promoted_product');
  //   });
  //   print("hehehe ${promotedProduct.toString()}");

  //   _productInfo = await getProductInfo();

  //   setState(() {
  //     data = _productInfo;
  //   });
  // }

  // Future<Product> getProductInfo() async {
  //   final product = (await APIService().getProductById(productId: promotedProduct.toString()))!;
  //   print("Product details fetched");
  //   return product;
  // }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime nextSat = today.add(
      Duration(
        days: (DateTime.saturday - today.weekday) % DateTime.daysPerWeek,
        hours: (24 - DateTime.now().hour),
        minutes: (60 - DateTime.now().minute),
        seconds: (60 - DateTime.now().second),
      ),
    );

    String photoUrl = widget.data!.photo!.photos![0].name.toString();
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
                width: Get.width,
                height: Get.height,
                child: Image.asset(
                  "assets/icons/abstract-bg2.jpg",
                  fit: BoxFit.cover,
                )),
            Center(
              child: Container(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    verticalSpaceSmall,
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 2),
                          ],
                        ),
                        child: InkWell(
                          child: Icon(
                            Icons.navigate_before,
                            size: 40,
                          ),
                          onTap: () => NavigationService.back(),
                        ),
                      ),
                    ),
                    // Text(data!.name.toString()),
                    verticalSpaceSmall,
                    Text(
                      "Stand a chance to win this!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: logoRed),
                    ),
                    verticalSpaceSmall,
                    Container(
                      height: 250,
                      width: 250,
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: FastCachedImage(
                          // child: CachedNetworkImage(
                          url:
                              // imageUrl:
                              '$PRODUCT_PHOTO_BASE_URL/${widget.data?.key}/$photoUrl-small.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    verticalSpaceLarge,
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                            ),
                          ]),
                      child: CountDownText(
                        due: nextSat,
                        finishedText: "Done",
                        showLabel: true,
                        longDateName: false,
                        daysTextLong: " Day ",
                        hoursTextLong: " Hr ",
                        minutesTextLong: " Min ",
                        secondsTextLong: " S ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                    verticalSpaceSmall,
                    Text(
                      "Until we announce the Lucky winner!",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    verticalSpaceSmall,
                    Container(
                      width: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: lightGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (_) => PromotionScreen()));
                          BaseController.goToProductPage(widget.data!);
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
