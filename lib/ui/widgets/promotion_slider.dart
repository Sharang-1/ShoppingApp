// import 'package:cached_network_image/cached_network_image.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../constants/route_names.dart';
import '../../constants/server_urls.dart';
import '../../models/productPageArg.dart';
import '../../models/promotions.dart';
import '../../services/navigation_service.dart';
import '../shared/shared_styles.dart';
import 'shimmer/shimmer_widget.dart';

class PromotionSlider extends StatefulWidget {
  final List<Promotion> promotions;
  final double aspectRatio;

  const PromotionSlider({
    Key? key,
    required this.promotions,
    this.aspectRatio = 1.6,
  }) : super(key: key);

  @override
  _PromotionSliderState createState() => _PromotionSliderState();
}

class _PromotionSliderState extends State<PromotionSlider> {
  int _current = 0;
  int _timeOut = 10;
  late DefaultCacheManager defaultCacheManager;

  @override
  void initState() {
    defaultCacheManager = DefaultCacheManager();
    // _timeOut = widget.promotions.isEmpty;
    FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 15));
    if (widget.promotions.isNotEmpty) {
      _timeOut = widget.promotions.first.time! as int;
    } else {
      _timeOut = 3;
    }

    // _timeOut = widget.promotions?.isNotEmpty ?? false
    //     ? widget.promotions.first.time
    //     : 3;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 20,
                offset: Offset(3, 3),
              ),
            ],
          ),
          child: CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              autoPlayInterval: Duration(seconds: _timeOut),
              pauseAutoPlayOnTouch: true,
              aspectRatio: widget.aspectRatio,
              enableInfiniteScroll: true,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                  // _timeOut = widget.promotions[index].time as int ?? 3;
                  _timeOut = widget.promotions[index].time as int;
                });
              },
            ),
            items: widget.promotions.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return InkWell(
                    onTap: () async {
                      // var promoTitle = i?.name;
                      // List<String> productIds =
                      //     i?.products?.map((e) => e.toString())?.toList();

                      if (i.exclusive ?? false) {
                        return await NavigationService.to(ProductsListRoute,
                            arguments: ProductPageArg(
                              promotionKey: i.key,
                              subCategory: 'Designer',
                              queryString:
                                  "accountKey=${i.filter};sortField=price;sortOrder=asc;",
                              sellerPhoto: "$SELLER_PHOTO_BASE_URL/${i.filter}",
                            ));
                      }

                      return NavigationService.to(ProductsListRoute,
                          arguments: ProductPageArg(
                            title: i.name ?? '',
                            queryString: "",
                            subCategory: "",
                            promotionKey: i.key,
                            demographicIds: i.demographics
                                    ?.map((e) => e.id ?? 0)
                                    .toList() ??
                                [],
                          )
                          // i.demographics.map((e) => e?.id)?.toList() ??
                          //     []),
                          );

                      // Navigator.push(
                      //   context,
                      //   new MaterialPageRoute(
                      //     builder: (context) => PromotionProduct(
                      //       promotionId: i?.key,
                      //       productIds: productIds ?? [],
                      //       promotionTitle: promoTitle,
                      //       demographicIds:
                      //           i?.demographics?.map((e) => e?.id)?.toList(),
                      //     ),
                      //   ),
                      // );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(curve15),
                          ),
                          width: MediaQuery.of(context).size.width - 10,
                          // child: CachedNetworkImage(
                          child: FastCachedImage(
                            // cacheManager: defaultCacheManager,
                            fit: BoxFit.cover,
                            // placeholder:
                            loadingBuilder: (context, url) => ShimmerWidget(),
                            // Image.asset(
                            //   "assets/images/promotion_preloading.png",
                            //   fit: BoxFit.cover,
                            // ),
                            // imageUrl:
                            url: "$PROMOTION_PHOTO_BASE_URL/${i.key}",
                            // errorWidget:
                            errorBuilder: (context, url, error) =>
                                ShimmerWidget(),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
        if (widget.promotions.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.promotions.map((url) {
              int index = widget.promotions.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Color.fromRGBO(190, 80, 95, 0.9)
                      : Color.fromRGBO(0, 0, 0, 0.4),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  @override
  void dispose() async {
    super.dispose();
  }
}

class BottomPromotion extends StatelessWidget {
  const BottomPromotion({Key? key, required this.promotion}) : super(key: key);

  final Promotion promotion;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () async {
          await NavigationService.to(
            ProductsListRoute,
            arguments: ProductPageArg(
                title: promotion.name,
                queryString: null,
                subCategory: null,
                promotionKey: promotion.key,
                demographicIds:
                    promotion.demographics?.map((e) => e.id ?? 0).toList() ??
                        []),
          );

          // String promoTitle = promotion?.name ?? '';
          // List<String> productIds =
          //     promotion?.products?.map((e) => e.toString())?.toList() ?? [];
          // List<int> demographicIds =
          //     promotion?.demographics?.map((e) => e?.id)?.toList() ?? [];

          // Navigator.push(
          //   context,
          //   new MaterialPageRoute(
          //     builder: (context) => PromotionProduct(
          //       promotionId: promotion?.key,
          //       productIds: productIds ?? [],
          //       promotionTitle: promoTitle,
          //       demographicIds:
          //           promotion?.demographics?.map((e) => e?.id)?.toList(),
          //     ),
          //   ),
          // );
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: SizedBox(
            height: (MediaQuery.of(context).size.width) / 1.6,
            width: MediaQuery.of(context).size.width,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(curve5),
              // child: CachedNetworkImage(
              child: FastCachedImage(
                fit: BoxFit.cover,
                // placeholder:
                loadingBuilder: (context, url) => ShimmerWidget(),
                // Image.asset(
                //   "assets/images/designer_preloading.png",
                //   fit: BoxFit.cover,
                // ),
                // imageUrl:
                url: "$PROMOTION_PHOTO_BASE_URL/${promotion.key}",
                // errorWidget:
                errorBuilder: (context, url, error) => ShimmerWidget(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
