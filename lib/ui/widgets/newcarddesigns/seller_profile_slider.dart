import 'package:compound/locator.dart';
import 'package:compound/constants/server_urls.dart';
import 'package:compound/models/sellerProfile.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/ui/shared/shared_styles.dart';
import 'package:compound/ui/views/gallery_view.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SellerProfilePhotos extends StatelessWidget {
  final String accountId;
  final APIService _apiService = locator<APIService>();

  SellerProfilePhotos({
    Key key,
    @required this.accountId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _apiService.getSellerProfile(accountId),
      builder: (c, AsyncSnapshot<SellerProfile> s) {
        if (s.connectionState != ConnectionState.done ||
            s.data == null ||
            s.data.photos == null ||
            s.data.photos.length == 0) {
          return FadeInImage.assetNetwork(
            fadeInCurve: Curves.easeIn,
            placeholder: "assets/images/product_preloading.png",
            image: "assets/images/product_preloading.png",
            imageErrorBuilder: (context, error, stackTrace) => Image.asset("assets/images/product_preloading.png", fit: BoxFit.cover,),
            fit: BoxFit.cover,
          );
        }

        var images = s.data.photos
            .map((e) =>
                "$SELLER_PROFILE_PHOTO_BASE_URL/$accountId/profile/${e.name}")
            .toList();

        print("Photos");
        print(images);

        return CarouselSlider(
          options: CarouselOptions(
            autoPlay: false,
            pauseAutoPlayOnTouch: true,
            // pauseAutoPlayOnTouch: Duration(seconds: 10),
            aspectRatio: 1,
            enableInfiniteScroll: false,
            viewportFraction: 1.0,
          ),
          items: images.map(
            (i) {
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () => open(context, images, images.indexOf(i)),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(curve15)),
                      width: MediaQuery.of(context).size.width,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: i,
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      ),
                    ),
                  );
                },
              );
            },
          ).toList(),
        );
      },
    );
  }

  void open(BuildContext context, final List<String> imgList, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: imgList,
          initialIndex: index,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
