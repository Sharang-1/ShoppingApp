import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:compound/constants/server_urls.dart';
import 'package:compound/models/promotions.dart';
import 'package:compound/ui/shared/shared_styles.dart';
import 'package:compound/ui/views/promotion_products_view.dart';
import 'package:flutter/material.dart';

class PromotionSlider extends StatefulWidget {
  final List<Promotion> promotions;
  final double aspectRatio;

  const PromotionSlider({
    Key key,
    this.promotions,
    this.aspectRatio = 1.6,
  }) : super(key: key);

  @override
  _PromotionSliderState createState() => _PromotionSliderState();
}

class _PromotionSliderState extends State<PromotionSlider> {
  int _current = 0;
  int _timeOut = 10;

  @override
  void initState() {
    _timeOut = widget.promotions.first.time;
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
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: CarouselSlider(
              autoPlay: true,
              autoPlayInterval: Duration(seconds: _timeOut),
              pauseAutoPlayOnTouch: Duration(seconds: 10),
              aspectRatio: widget.aspectRatio,
              enableInfiniteScroll: true,
              viewportFraction: 1.0,
              onPageChanged: (index) {
                setState(() {
                  _current = index;
                  _timeOut = widget?.promotions[index]?.time ?? 3;
                });
              },
              items: widget.promotions.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () {
                        var promoTitle = i?.name;
                        List<String> productIds = i?.products?.map((e) => e.toString())?.toList();
                        print(productIds);
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => PromotionProduct(
                              productIds: productIds ?? [],
                              promotionTitle: promoTitle,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(curve15)),
                        width: MediaQuery.of(context).size.width,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: "$PROMOTION_PHOTO_BASE_URL/${i.key}",
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
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
                      ? Color.fromRGBO(0, 0, 0, 0.9)
                      : Color.fromRGBO(0, 0, 0, 0.4),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
