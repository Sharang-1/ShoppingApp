import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../shared/shared_styles.dart';
import 'gallery_view.dart';

class HomeSlider extends StatefulWidget {
  final List<String> imgList;
  final List<String> videoList;
  final String sizeChartUrl;
  final double aspectRatio;
  final bool fromHome;
  final bool fromExplore;
  final bool fromProduct;

  const HomeSlider({
    Key key,
    this.imgList,
    this.videoList = const [],
    this.sizeChartUrl = '',
    this.aspectRatio = 1.6,
    this.fromHome = false,
    this.fromExplore = false,
    this.fromProduct = false,
  }) : super(key: key);

  @override
  _HomeSliderState createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  int _current = 0;
  List<VideoPlayerController> videoControllers = [];

  @override
  void initState() {
    print("Videos: ${widget.videoList.toString()}");

    widget.videoList.forEach((videoUrl) {
      videoControllers.add(VideoPlayerController.network(
        videoUrl,
      )
        ..initialize()
        ..setVolume(0.0));
    });
    super.initState();
  }

  @override
  void dispose() {
    videoControllers.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: widget.fromExplore || widget.fromProduct
              ? null
              : BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: widget.fromExplore
                    ? BorderRadius.zero
                    : BorderRadius.circular(20.0),
                child: CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: false,
                      aspectRatio: widget.aspectRatio,
                      enableInfiniteScroll: false,
                      viewportFraction: 1.0,
                      pauseAutoPlayOnTouch: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      },
                    ),
                    items: [
                      ...widget.imgList.map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return GestureDetector(
                              onTap: widget.fromExplore
                                  ? null
                                  : () {
                                      if (!widget.fromHome) {
                                        open(
                                            context, widget.imgList.indexOf(i));
                                      }
                                    },
                              child: Hero(
                                tag: 'productPhotos',
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(curve15)),
                                  width: MediaQuery.of(context).size.width,
                                  child: CachedNetworkImage(
                                    maxHeightDiskCache: 200,
                                    maxWidthDiskCache: 200,
                                    fit: BoxFit.contain,
                                    imageUrl: i,
                                    placeholder: (context, e) => Center(
                                      child: Image.asset(
                                        "assets/images/loading_img.gif",
                                        height: 50,
                                        width: 50,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        new Icon(Icons.error),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                      if (videoControllers.isNotEmpty)
                        ...videoControllers
                            .map((videoController) => FlickVideoPlayer(
                                  flickVideoWithControls:
                                      FlickVideoWithControls(
                                    backgroundColor: Colors.white,
                                    controls: FlickPortraitControls(),
                                  ),
                                  flickManager: FlickManager(
                                    videoPlayerController: videoController,
                                    autoPlay: false,
                                  ),
                                ))
                            .toList(),
                      if (widget.sizeChartUrl.isNotEmpty)
                        Builder(
                          builder: (BuildContext context) {
                            return GestureDetector(
                              onTap: widget.fromExplore
                                  ? null
                                  : () {
                                      if (!widget.fromHome) {
                                        open(context,
                                            (widget.imgList.length + 1));
                                      }
                                    },
                              child: Hero(
                                tag: 'productPhotos',
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(curve15)),
                                  width: MediaQuery.of(context).size.width,
                                  child: CachedNetworkImage(
                                    maxHeightDiskCache: 200,
                                    maxWidthDiskCache: 200,
                                    fit: BoxFit.contain,
                                    imageUrl: widget.sizeChartUrl,
                                    placeholder: (context, e) => Center(
                                      child: Image.asset(
                                        "assets/images/loading_img.gif",
                                        height: 50,
                                        width: 50,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        new Icon(Icons.error),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    ]),
              ),
              if (((widget?.imgList?.length ?? 0) +
                          (widget?.videoList?.length ?? 0)) >
                      1 &&
                  (widget.fromExplore))
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...widget.imgList.map((url) {
                        int index = widget.imgList.indexOf(url);
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current == index
                                ? Color.fromRGBO(0, 0, 0, 0.9)
                                : Color.fromRGBO(0, 0, 0, 0.4),
                          ),
                        );
                      }).toList(),
                      if ((widget?.videoList?.length ?? 0) > 0)
                        ...widget.videoList
                            .map(
                              (e) => Container(
                                width: 8.0,
                                height: 8.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _current ==
                                          (widget.imgList.length +
                                              widget.videoList.indexOf(e))
                                      ? Color.fromRGBO(0, 0, 0, 0.9)
                                      : Color.fromRGBO(0, 0, 0, 0.4),
                                ),
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 8,
                                ),
                              ),
                            )
                            .toList(),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (((widget?.imgList?.length ?? 0) +
                    (widget?.videoList?.length ?? 0) +
                    (widget.sizeChartUrl == null ? 0 : 1)) >
                1 &&
            !(widget.fromExplore))
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...widget.imgList.map((url) {
                int index = widget.imgList.indexOf(url);
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
              if ((widget?.videoList?.length ?? 0) > 0)
                ...widget.videoList
                    .map(
                      (e) => Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current ==
                                  (widget.imgList.length +
                                      widget.videoList.indexOf(e))
                              ? Color.fromRGBO(0, 0, 0, 0.9)
                              : Color.fromRGBO(0, 0, 0, 0.4),
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 8,
                        ),
                      ),
                    )
                    .toList(),
              if (widget.sizeChartUrl.isNotEmpty)
                Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current ==
                            (widget.imgList.length + widget.videoList.length)
                        ? Color.fromRGBO(0, 0, 0, 0.9)
                        : Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                ),
            ],
          ),
      ],
    );
  }

  void open(BuildContext context, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: [
            ...widget.imgList,
            if (widget.sizeChartUrl.isNotEmpty) widget.sizeChartUrl
          ],
          initialIndex: index,
          scrollDirection: Axis.horizontal,
          loadingBuilder: (context, e) => Center(
            child: Image.asset(
              "assets/images/loading_img.gif",
              height: 50,
              width: 50,
            ),
          ),
          backgroundDecoration: BoxDecoration(color: Colors.white),
        ),
      ),
    );
  }
}
