import 'dart:convert';

import 'package:compound/controllers/home_controller.dart';
import 'package:compound/models/calculatedPrice.dart';
import 'package:compound/models/groupOrderModel.dart' as groupOrder;
import 'package:compound/models/orderV2.dart' as orderV2;
import 'package:compound/services/api/api_service.dart';
import 'package:compound/ui/widgets/section_builder.dart';
import 'package:compound/utils/lang/translation_keys.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../app/groupOrderData.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/cart_count_controller.dart';
import '../../controllers/grid_view_builder/cart_grid_view_builder_controller.dart';
import '../../locator.dart';
import '../../models/cart.dart';
import '../../models/grid_view_builder_filter_models/cartFilter.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/cart_tile.dart';
import '../widgets/custom_stepper.dart';
import '../widgets/custom_text.dart';
import 'cart_select_delivery_view.dart';

class CartView extends StatefulWidget {
  final String productId;
  CartView({Key? key, this.productId = ""}) : super(key: key);

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  CartFilter? filter;
  UniqueKey key = UniqueKey();
  Key? uniqueKey;

  final refreshController = RefreshController(initialRefresh: false);
  bool isPromocodeApplied = false;
  List<String> exceptProductIDs = [];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      init: CartController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            MY_BAG.tr,
            style: TextStyle(
              fontFamily: headingFont,
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        // bottomNavigationBar: Container(
        //   // color: Colors.grey[200],
        //   padding: EdgeInsets.only(
        //     left: 8,
        //     right: 8,
        //     bottom: MediaQuery.of(context).padding.bottom,
        //   ),
        //   child: ElevatedButton(
        //       style: ElevatedButton.styleFrom(
        //         primary: lightGreen,
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(5),
        //         ),
        //       ),
        //       onPressed: () async => await BaseController.showSizePopup(),
        //       child: CustomText(
        //         ADD_MEASUREMENTS.tr,
        //         align: TextAlign.center,
        //         color: Colors.white,
        //         isBold: true,
        //         fontSize: 14,
        //       )),
        // ),

        body: SafeArea(
          top: true,
          left: false,
          right: false,
          bottom: false,
          child: SmartRefresher(
            enablePullDown: true,
            footer: null,
            header: WaterDropHeader(
              waterDropColor: logoRed,
              refresh: Center(
                child: Center(
                  child: Image.asset(
                    "assets/images/loading_img.gif",
                    height: 25,
                    width: 25,
                  ),
                ),
              ),
              complete: Container(),
            ),
            controller: refreshController,
            onRefresh: () async {
              setState(() {
                key = new UniqueKey();
              });

              await Future.delayed(Duration(milliseconds: 100));

              refreshController.refreshCompleted(resetFooterState: true);
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  left: screenPadding,
                  right: screenPadding,
                  top: 10,
                  bottom: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    verticalSpace(10),
                    const CutomStepper(
                      step: 1,
                    ),
                    verticalSpace(20),
                    Obx(
                      () => locator<CartCountController>().count.value > 0
                          ? CustomText(
                              "${ITEMS_IN_BAG.tr}: ${locator<CartCountController>().count.value}",
                              isBold: true,
                            )
                          : Container(),
                    ),
                    Center(
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                    // ? cart item tile
                    FutureBuilder(
                      future: Future.delayed(Duration(seconds: 1)),
                      builder: (c, s) => s.connectionState == ConnectionState.done
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SectionBuilder(
                                  key: uniqueKey ?? UniqueKey(),
                                  context: context,
                                  filter: CartFilter(productId: widget.productId),
                                  layoutType: LayoutType.VIEW_CART_LAYOUT,
                                  controller: CartGridViewBuilderController(),
                                  onEmptyList: () {},
                                  scrollDirection: Axis.horizontal,
                                  tileBuilder:
                                      (BuildContext context, data, index, onDelete, onUpdate) {
                                    Fimber.d("test");
                                    print((data as Item).toJson());

                                    final Item dItem = data;
                                    exceptProductIDs.add(dItem.product!.key ?? "");

                                    return CartTile(
                                      index: index,
                                      item: dItem,
                                      onDelete: (int index) async {
                                        final value = await onDelete(index);
                                        print("Delete product index: $index");
                                        if (!value) return;
                                        await controller
                                            .removeFromCartLocalStore(dItem.productId.toString());
                                        locator<CartCountController>().decrementCartCount();
                                        try {
                                          await controller
                                              .removeProductFromCartEvent(dItem.product!);
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                    );
                                  },
                                ),
                                FutureBuilder<bool>(
                                  initialData: false,
                                  future: controller.hasProducts(),
                                  builder: (c, s) => (!controller.isCartEmpty &&
                                          controller.showPairItWith)
                                      ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            verticalSpace(10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SizedBox(
                                                  height: 40,
                                                  child: OutlinedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      elevation: 0,
                                                      primary: Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        side: BorderSide(
                                                          color: logoRed,
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () {},
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(vertical: 8),
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                            'assets/images/coupon_icon.png',
                                                            // color: Colors.black,
                                                            height: 30,
                                                            width: 30,
                                                          ),
                                                          horizontalSpaceSmall,
                                                          Text(
                                                            APPLY_COUPON.tr,
                                                            style: TextStyle(
                                                              color: logoRed,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                horizontalSpaceSmall,
                                                SizedBox(
                                                  height: 40,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      elevation: 0,
                                                      primary: logoRed,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                    ),
                                                    onPressed: proccedToOrder,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(vertical: 8),
                                                      child: Text(
                                                        PROCEED_TO_ORDER.tr,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  // child: PairItWithWidget(
                                                  //   exceptProductIDs:
                                                  //       exceptProductIDs,
                                                  //   onEmpty: () async {
                                                  //     await Future.delayed(
                                                  //       Duration(
                                                  //         milliseconds: 5,
                                                  //       ),
                                                  //     );
                                                  //     controller.hidePairItWith();
                                                  //   },
                                                  //   onProductClicked:
                                                  //       (product) async {
                                                  //     showModalBottomSheet(
                                                  //       context: context,
                                                  //       builder: (context) =>
                                                  //           Container(
                                                  //         height:
                                                  //             MediaQuery.of(context)
                                                  //                     .size
                                                  //                     .height *
                                                  //                 0.9,
                                                  //         child: ProductIndiView(
                                                  //           data: product,
                                                  //           fromCart: true,
                                                  //         ),
                                                  //       ),
                                                  //       isScrollControlled: true,
                                                  //     ).then((void v) => setState(
                                                  //         () =>
                                                  //             {key = UniqueKey()}));
                                                  //   },
                                                  // ),
                                                ),
                                              ],
                                            ),
                                            verticalSpace(15),
                                          ],
                                        )
                                      : Container(),
                                ),
                              ],
                            )
                          : Container(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  proccedToOrder() async {
    GroupOrderData.cartProducts.clear();
    var total = 0.0;
    var data = await locator<APIService>().getCart();
    if (data != null) {
      var _cartItems = data.items;
      // var _cartProducts = [];
      for (var i = 0; i < _cartItems!.length; i++) {
        var finalTotal = _cartItems[i].product!.cost!.costToCustomer!.toDouble() *
            _cartItems[i].quantity!.toInt();
        total = total + finalTotal;
        groupOrder.GroupOrderModel cartItem = groupOrder.GroupOrderModel(
          productId: _cartItems[i].productId.toString(),
          variation: groupOrder.Variation(
            size: _cartItems[i].size.toString(),
            quantity: _cartItems[i].quantity?.toInt(),
            color: _cartItems[i].color.toString(),
          ),
          orderQueue: groupOrder.OrderQueue(
            clientQueueId: (i + 1).toString(),
          ),
        );

        GroupOrderData.cartProducts.add(cartItem);
        if (kDebugMode) print("hi");
        String jsonObj = jsonEncode(cartItem);
        if (kDebugMode) print(jsonObj);
      }
      Navigator.push(
        context,
        PageTransition(
          child: SelectAddress(
            products: GroupOrderData.cartProducts,
            payTotal: total,
          ),
          type: PageTransitionType.rightToLeft,
        ),
      );
    }
    print(total);
    if (kDebugMode) print("cart products");
    String cartJson = jsonEncode(GroupOrderData.cartProducts);
    if (kDebugMode) print(cartJson);
  }
}
