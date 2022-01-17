import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../utils/lang/translation_keys.dart';
import '../shared/app_colors.dart';
import '../widgets/custom_text.dart';
import 'home_view_list.dart';

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    required this.initialIndex,
    required this.galleryItems,
    this.showImageLabel = true,
    this.isSizeChart = false,
    this.appbarColor,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder? loadingBuilder;
  final Decoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<String> galleryItems;
  final Axis scrollDirection;
  final bool showImageLabel;
  final bool isSizeChart;
  final Color? appbarColor;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  late int currentIndex;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: appBarIconColor),
        backgroundColor: widget.appbarColor ?? Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  PhotoViewGallery.builder(
                    scrollPhysics: const BouncingScrollPhysics(),
                    builder: _buildItem,
                    itemCount: widget.galleryItems.length,
                    loadingBuilder: widget.loadingBuilder,
                    backgroundDecoration:
                        widget.backgroundDecoration as BoxDecoration,
                    pageController: widget.pageController,
                    onPageChanged: onPageChanged,
                    scrollDirection: widget.scrollDirection,
                  ),
                  if (widget.showImageLabel)
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "Image ${currentIndex + 1} of ${widget.galleryItems.length}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                          decoration: null,
                        ),
                      ),
                    )
                ],
              ),
            ),
            if (widget.isSizeChart) ...[
              SectionDivider(),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        MEASUREMENT_GUIDE.tr,
                        fontWeight: FontWeight.w400,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Image.asset(
                            "assets/images/size_chart_guide.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final String item = widget.galleryItems[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: NetworkImage(item),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: item),
    );
  }
}
