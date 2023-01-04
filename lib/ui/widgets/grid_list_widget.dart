import 'package:async/async.dart';
import 'package:compound/ui/shared/app_colors.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/grid_view_builder/base_grid_view_builder_controller.dart';
import '../../models/grid_view_builder_filter_models/base_filter_model.dart';
import '../shared/ui_helpers.dart';
import 'shimmer/shimmer_widget.dart';

// Type and Enum declarations
enum LoadMoreStatus { LOADING, STABLE }

typedef TileFunctionBuilder = Widget Function(BuildContext context, dynamic data, int index,
    Future<bool> Function(int) onDelete, Future<bool>? Function(int, dynamic)? onUpdate);

class GridListWidget<P, I> extends StatelessWidget {
  final BaseFilterModel? filter;
  final BaseGridViewBuilderController controller;
  final TileFunctionBuilder tileBuilder;
  final int gridCount;
  final double childAspectRatio;
  final bool disablePagination;
  final Axis scrollDirection;
  final Widget? emptyListWidget;
  final Widget? loadingWidget;
  final Function onEmptyList;

  const GridListWidget({
    Key? key,
    required this.context,
    required this.filter,
    required this.controller,
    required this.gridCount,
    required this.tileBuilder,
    this.childAspectRatio = 1.0,
    this.disablePagination = false,
    this.scrollDirection = Axis.vertical,
    this.emptyListWidget,
    this.loadingWidget,
    required this.onEmptyList,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BaseGridViewBuilderController>(
      init: controller..init(),
      global: false,
      builder: (controller) => filter != null
          ? CustomGridViewFutureBuilder<P, I>(
              filter: filter!,
              gridCount: gridCount,
              tileBuilder: tileBuilder,
              controller: controller,
              childAspectRatio: childAspectRatio,
              disablePagination: disablePagination,
              scrollDirection: scrollDirection,
              emptyListWidget: emptyListWidget == null ? EmptyListWidget() : emptyListWidget!,
              loadingWidget: loadingWidget,
              onEmptyList: () {
                onEmptyList();
              },
            )
          : Container(
              child: null,
            ),
    );
  }
}

class CustomGridViewFutureBuilder<P, I> extends StatefulWidget {
  const CustomGridViewFutureBuilder({
    Key? key,
    required this.filter,
    required this.gridCount,
    required this.tileBuilder,
    required this.controller,
    this.childAspectRatio = 1.0,
    required this.disablePagination,
    this.scrollDirection = Axis.vertical,
    this.emptyListWidget,
    this.loadingWidget,
    required this.onEmptyList,
  }) : super(key: key);

  final BaseFilterModel filter;
  final int gridCount;
  final TileFunctionBuilder tileBuilder;
  final BaseGridViewBuilderController controller;
  final double childAspectRatio;
  final bool disablePagination;
  final Axis scrollDirection;
  final Widget? emptyListWidget;
  final Widget? loadingWidget;
  final Function onEmptyList;

  @override
  _CustomGridViewFutureBuilderState<P, I> createState() =>
      _CustomGridViewFutureBuilderState<P, I>();
}

class _CustomGridViewFutureBuilderState<P, I> extends State<CustomGridViewFutureBuilder<P, I>> {
  late Future<P> future;
  late BaseFilterModel filter;

  @override
  void initState() {
    filter = widget.filter;
    future = widget.controller.getData(
      filterModel: filter,
      pageNumber: 1,
    ) as Future<P>;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomGridViewFutureBuilder<P, I> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filter != widget.filter) {
      setState(() {
        filter = widget.filter;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<P>(
      future: future,
      builder: (context, snapshots) {
        if (snapshots.hasError) {
          print(snapshots.error);
          return Center(child: Text(snapshots.error.toString()));
        }
        switch (snapshots.connectionState) {
          case ConnectionState.waiting:
            return widget.loadingWidget == null
                ? ShimmerWidget()
                // Center(
                //     child: Image.asset(
                //       "assets/images/loading_img.gif",
                //       height: 50,
                //       width: 50,
                //     ),
                //   )
                : widget.loadingWidget!;
          case ConnectionState.done:
            print(snapshots.data);
            return PaginatedGridView<P, I>(
              data: snapshots.data!,
              filter: widget.filter,
              controller: widget.controller,
              gridCount: widget.gridCount,
              tileBuilder: widget.tileBuilder,
              childAspectRatio: widget.childAspectRatio,
              disablePagination: widget.disablePagination,
              scrollDirection: widget.scrollDirection,
              emptyListWidget: widget.emptyListWidget!,
              onEmptyList: () {
                widget.onEmptyList();
              },
            );
          default:
            return Container();
        }
      },
    );
  }
}

class PaginatedGridView<P, I> extends StatefulWidget {
  final BaseGridViewBuilderController controller;
  final P data;
  final BaseFilterModel filter;
  final TileFunctionBuilder tileBuilder;
  final int gridCount;
  final double childAspectRatio;
  final bool disablePagination;
  final bool showScrollIndicator;
  final Axis scrollDirection;
  final Widget? emptyListWidget;
  final Function? onEmptyList;

  const PaginatedGridView({
    Key? key,
    required this.data,
    required this.filter,
    required this.controller,
    required this.gridCount,
    required this.tileBuilder,
    this.childAspectRatio = 1,
    required this.disablePagination,
    this.showScrollIndicator = false,
    this.scrollDirection = Axis.vertical,
    this.emptyListWidget,
    required this.onEmptyList,
  }) : super(key: key);

  @override
  _PaginatedGridViewState<I> createState() => _PaginatedGridViewState<I>();
}

class _PaginatedGridViewState<I> extends State<PaginatedGridView> {
  final ScrollController _scrollController = new ScrollController();
  LoadMoreStatus loadMoreStatus = LoadMoreStatus.STABLE;
  List<I> items = [];
  Map<int, List<I>> paginatedItems = {};
  late int rangeStart;
  late int rangeEnd;
  late int currentPage;
  int? pages;
  int threshold = 3;
  int itemsPerPage = 40;
  CancelableOperation? itemOperation;

  @override
  void initState() {
    items = widget.data.items;
    pages = (widget.data.items.length / itemsPerPage).ceil();
    currentPage = 1;
    if(items.length > 0) mapItems();
    _rangeSet();
    super.initState();
  }

  void mapItems() {
    for (var k = 1; k <= pages!; k++) {
      List<I> temp = [];
      // handle last items
      var e = k * itemsPerPage;
      var s = e - itemsPerPage;

      if (e > items.length) {
        e = items.length;
      }
      for (var i = s; i < e; i++) {
        temp.add(items[i]);
      }

      paginatedItems[k] = temp;
    }
  }

  void navigatePages(int pageNumber) {
    setState(() {
      currentPage = pageNumber;
      _rangeSet();
    });
  }

  void nextPage() {
    if (currentPage < pages!)
      setState(() {
        currentPage++;
        _rangeSet();
      });
  }

  void prevPage() {
    if (currentPage > 1)
      setState(() {
        currentPage--;
        _rangeSet();
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    if (itemOperation != null) itemOperation!.cancel();
    super.dispose();
  }

  Widget _defaultControlButton(Widget icon) {
    return AbsorbPointer(
      child: TextButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(5.0),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
          minimumSize: MaterialStateProperty.all(Size(40, 40)),
          foregroundColor: MaterialStateProperty.all(logoRed),
          backgroundColor: MaterialStateProperty.all(Colors.white),
        ),
        onPressed: () {},
        child: icon,
      ),
    );
  }

  Icon iconToFirst = Icon(Icons.first_page);
  Icon iconPrevious = Icon(Icons.keyboard_arrow_left);
  Icon iconNext = Icon(Icons.keyboard_arrow_right);
  Icon iconToLast = Icon(Icons.last_page);

  void _rangeSet() {
    rangeStart = currentPage % threshold == 0
        ? currentPage - threshold
        : (currentPage ~/ threshold) * threshold;

    rangeEnd = rangeStart + threshold;
  }

  @override
  Widget build(BuildContext context) {
    if ((widget.onEmptyList != null) && (items.isEmpty))
      widget.onEmptyList!();
    return NotificationListener(
      onNotification: !(widget.disablePagination) ? onNotification : null,
      child: (items.isNotEmpty) && paginatedItems[currentPage]?.length != 0
          ? SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GridView.builder(
                  shrinkWrap: widget.scrollDirection == Axis.vertical,
                  scrollDirection: widget.scrollDirection,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        widget.scrollDirection == Axis.vertical ? widget.gridCount : 1,
                    childAspectRatio: widget.childAspectRatio,
                  ),
                  // controller: _scrollController,
                  itemCount: paginatedItems[currentPage]?.length,
                  physics: NeverScrollableScrollPhysics(),
                  // physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) => widget.tileBuilder(
                      context, paginatedItems[currentPage]?[index], index, onDelete, null),
                ),
                (widget.disablePagination || pages! < 2)
                    ? Container()
                    : Container(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(horizontal : 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () => navigatePages(1),
                            child: _defaultControlButton(iconToFirst),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          InkWell(
                            onTap: () => prevPage(),
                            child: _defaultControlButton(iconPrevious),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ...List.generate(
                            rangeEnd <= pages! ? threshold : pages! % threshold,
                            (idx) => Flexible(
                              child: InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () => navigatePages(idx + 1 + rangeStart),
                                child: Container(
                                  margin: const EdgeInsets.all(4),
                                  height: 40,
                                  width: 40,
          
                                  // padding:
                                  // const EdgeInsets.symmetric(vertical: 10, horizontal: ),
                                  decoration: BoxDecoration(
                                    color: (currentPage - 1) % threshold == idx
                                        ? logoRed
                                        : Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(4)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0.0, 1.0), //(x,y)
                                        blurRadius: 6.0,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${idx + 1 + rangeStart}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: (currentPage - 1) % threshold == idx
                                            ? Colors.white
                                            : logoRed,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () => nextPage(),
                            child: _defaultControlButton(iconNext),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          InkWell(
                            onTap: () => navigatePages(pages!),
                            child: _defaultControlButton(iconToLast),
                          ),
                        ],
                      ),
                    ),
                // Row(
                //   children: [
                //     // button for prev
                //     // button for next
                //   ],
                // )
              ],
            ),
          )
          : widget.emptyListWidget!,
    );
  }

  Future<bool> onDelete(int index) async {
    print("Current ID::::: " + index.toString());
    final item = items[index];
    print("Current Item");
    print(item);
    final res = await widget.controller.deleteData(item);
    if (res) {
      setState(() {
        print("Final Index");
        items.removeWhere((element) => element == item);
      });
      return true;
    }
    return false;
  }

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification && _scrollController.hasClients) {
      if (_scrollController.position.maxScrollExtent > _scrollController.offset &&
          _scrollController.position.maxScrollExtent - _scrollController.offset <= 50) {
        if (loadMoreStatus != null && loadMoreStatus == LoadMoreStatus.STABLE) {
          Fimber.d("calling again.................................................");
          loadMoreStatus = LoadMoreStatus.LOADING;
          itemOperation = CancelableOperation.fromFuture(widget.controller
              .getData(filterModel: widget.filter, pageNumber: currentPage + 1)
              .then((productObject) {
            currentPage = currentPage + 1;
            loadMoreStatus = LoadMoreStatus.STABLE;
            setState(() => items.addAll(productObject.items));
          }));
        }
      }
    }
    return true;
  }
}

class EmptyListWidget extends StatelessWidget {
  final String text, img;
  const EmptyListWidget({
    Key? key,
    this.text = "Fill Me Up!",
    this.img = "assets/images/empty_cart.png",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: Get.size.height * 0.7,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              verticalSpaceMedium,
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Image.asset(img),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
