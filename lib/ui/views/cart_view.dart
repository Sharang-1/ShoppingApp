import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
import '../widgets/grid_list_widget.dart';
import '../widgets/pair_it_with_widget.dart';
import 'product_individual_view.dart';

class CartView extends StatefulWidget {
  final String productId;
  CartView({Key key, this.productId = ""}) : super(key: key);

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  CartFilter filter;
  UniqueKey key = UniqueKey();
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
            "My Bag",
            style: TextStyle(
              fontFamily: headingFont,
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          // leading: BackButton(
          //   onPressed: () async {
          //     if (isPromocodeApplied)
          //       DialogService.showCustomDialog(AlertDialog(
          //         content: Text("Do you really want to leave cart ?"),
          //         actions: [
          //           ElevatedButton(
          //             onPressed: () {},
          //             child: Text("Yes"),
          //           ),
          //           ElevatedButton(
          //             onPressed: () {},
          //             child: Text("No"),
          //           )
          //         ],
          //       ));
          //     await NavigationService.offAll(HomeViewRoute);
          //   },
          // ),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
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
                child: CircularProgressIndicator(),
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
                              "Items in Bag: ${locator<CartCountController>().count.value}",
                              isBold: true,
                            )
                          : Container(),
                    ),
                    Center(
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                    FutureBuilder(
                      future: Future.delayed(Duration(seconds: 1)),
                      builder: (c, s) => s.connectionState ==
                              ConnectionState.done
                          ? Column(
                              children: [
                                GridListWidget<Cart, Item>(
                                  context: context,
                                  filter:
                                      CartFilter(productId: widget.productId),
                                  gridCount: 1,
                                  disablePagination: true,
                                  controller: CartGridViewBuilderController(),
                                  childAspectRatio: 1.6,
                                  tileBuilder: (BuildContext context, data,
                                      index, onDelete, onUpdate) {
                                    Fimber.d("test");
                                    print((data as Item).toJson());
                                    final Item dItem = data as Item;
                                    exceptProductIDs.add(dItem.product.key);
                                    return CartTile(
                                      index: index,
                                      item: dItem,
                                      onDelete: (int index) async {
                                        final value = await onDelete(index);
                                        if (value != true) return;
                                        await controller
                                            .removeFromCartLocalStore(
                                                dItem.productId.toString());
                                        locator<CartCountController>()
                                            .decrementCartCount();
                                        try {
                                          await controller
                                              .removeProductFromCartEvent();
                                        } catch (e) {}
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
                                          children: [
                                            verticalSpace(10),
                                            SizedBox(
                                              height: 260,
                                              child: PairItWithWidget(
                                                exceptProductIDs:
                                                    exceptProductIDs,
                                                onEmpty: () async {
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 5,
                                                    ),
                                                  );
                                                  controller.hidePairItWith();
                                                },
                                                onProductClicked:
                                                    (product) async {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    builder: (context) =>
                                                        SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.9,
                                                      child: ProductIndiView(
                                                        data: product,
                                                        fromCart: true,
                                                      ),
                                                    ),
                                                    isScrollControlled: true,
                                                  ).then((void v) => setState(
                                                      () =>
                                                          {key = UniqueKey()}));
                                                },
                                              ),
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
}
