import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:compound/constants/server_urls.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flick_video_player/flick_video_player.dart';

import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import 'gallery_view.dart';

class HomeSlider extends StatefulWidget {
  final List<String> imgList;
  final List<String> videoList;
  final double aspectRatio;
  final bool fromHome;
  final bool fromExplore;
  final bool fromProduct;

  const HomeSlider({
    Key key,
    this.imgList,
    this.videoList = const [],
    this.aspectRatio = 1.6,
    this.fromHome = false,
    this.fromExplore = false,
    this.fromProduct = false,
  }) : super(key: key);

  @override
  _HomeSliderState createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  List<String> imgList;
  int _current = 0;
  VideoPlayerController _playerController;

  @override
  void initState() {
    imgList = widget.imgList == null || widget.imgList.length == 0
        ? [
            'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
            'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
            'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
            'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
            'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
            'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
          ]
        : widget.imgList;

    print("Videos: ${widget.videoList.toString()}");

    if (widget.videoList.isNotEmpty)
      _playerController = VideoPlayerController.network(
        widget.videoList.first,
      )
        ..initialize()
        ..setVolume(0.0);
    super.initState();
  }

  @override
  void dispose() {
    if (_playerController != null) _playerController.dispose();
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
                      if (_playerController != null)
                        FlickVideoPlayer(
                          flickVideoWithControls: FlickVideoWithControls(
                            backgroundColor: Colors.white,
                            controls: FlickPortraitControls(),
                          ),
                          flickManager: FlickManager(
                            videoPlayerController: _playerController,
                            autoPlay: false,
                          ),
                        ),
                      ...imgList.map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return GestureDetector(
                              onTap: widget.fromExplore
                                  ? null
                                  : () {
                                      if (!widget.fromHome) {
                                        open(context, imgList.indexOf(i));
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
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        new Icon(Icons.error),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ]),
              ),
              if (imgList.length > 1 && (widget.fromExplore))
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imgList.map((url) {
                      int index = imgList.indexOf(url);
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
                  ),
                ),
            ],
          ),
        ),
        if (imgList.length > 1 && !(widget.fromExplore))
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.map((url) {
              int index = imgList.indexOf(url);
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

  void open(BuildContext context, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: imgList,
          initialIndex: index,
          scrollDirection: Axis.horizontal,
          loadingBuilder: (context, e) =>
              Center(child: CircularProgressIndicator()),
          backgroundDecoration: BoxDecoration(color: backgroundWhiteCreamColor),
        ),
      ),
    );
  }
}
