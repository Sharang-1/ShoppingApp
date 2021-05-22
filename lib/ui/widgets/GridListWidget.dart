import 'package:async/async.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../../controllers/grid_view_builder/base_grid_view_builder_controller.dart';
import '../../models/grid_view_builder_filter_models/base_filter_model.dart';
import '../shared/ui_helpers.dart';

// Type and Enum declarations
enum LoadMoreStatus { LOADING, STABLE }

typedef TileFunctionBuilder = Widget Function(
    BuildContext context,
    dynamic data,
    int index,
    Future<bool> Function(int) onDelete,
    Future<bool> Function(int, dynamic) onUpdate);

class GridListWidget<P, I> extends StatelessWidget {
  final BaseFilterModel filter;
  final BaseGridViewBuilderController controller;
  final TileFunctionBuilder tileBuilder;
  final int gridCount;
  final double childAspectRatio;
  final bool disablePagination;
  final Axis scrollDirection;
  final Widget emptyListWidget;
  final Widget loadingWidget;
  final Function onEmptyList;

  const GridListWidget({
    Key key,
    @required this.context,
    @required this.filter,
    @required this.controller,
    @required this.gridCount,
    @required this.tileBuilder,
    this.childAspectRatio = 1.0,
    this.disablePagination = false,
    this.scrollDirection = Axis.vertical,
    this.emptyListWidget,
    this.loadingWidget,
    this.onEmptyList,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BaseGridViewBuilderController>(
      init: controller..init(),
      global: false,
      builder: (controller) => filter != null
          ? CustomGridViewFutureBuilder<P, I>(
              filter: filter,
              gridCount: gridCount,
              tileBuilder: tileBuilder,
              controller: controller,
              childAspectRatio: childAspectRatio,
              disablePagination: disablePagination,
              scrollDirection: scrollDirection,
              emptyListWidget:
                  emptyListWidget == null ? EmptyListWidget() : emptyListWidget,
              loadingWidget: loadingWidget,
              onEmptyList: onEmptyList,
            )
          : Container(
              child: null,
            ),
    );
  }
}

class CustomGridViewFutureBuilder<P, I> extends StatefulWidget {
  const CustomGridViewFutureBuilder({
    Key key,
    @required this.filter,
    @required this.gridCount,
    @required this.tileBuilder,
    @required this.controller,
    this.childAspectRatio = 1.0,
    this.disablePagination,
    this.scrollDirection = Axis.vertical,
    this.emptyListWidget,
    this.loadingWidget,
    this.onEmptyList,
  }) : super(key: key);

  final BaseFilterModel filter;
  final int gridCount;
  final TileFunctionBuilder tileBuilder;
  final BaseGridViewBuilderController controller;
  final double childAspectRatio;
  final bool disablePagination;
  final Axis scrollDirection;
  final Widget emptyListWidget;
  final Widget loadingWidget;
  final Function onEmptyList;

  @override
  _CustomGridViewFutureBuilderState<P, I> createState() =>
      _CustomGridViewFutureBuilderState<P, I>();
}

class _CustomGridViewFutureBuilderState<P, I>
    extends State<CustomGridViewFutureBuilder<P, I>> {
  Future future;
  BaseFilterModel filter;

  @override
  void initState() {
    filter = widget.filter;
    future = widget.controller.getData(
      filterModel: filter,
      pageNumber: 1,
    );
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
                ? Center(child: CircularProgressIndicator())
                : widget.loadingWidget;
          case ConnectionState.done:
            print("snapshots.data");
            print(snapshots.data);
            return PaginatedGridView<P, I>(
              data: snapshots.data,
              filter: widget.filter,
              controller: widget.controller,
              gridCount: widget.gridCount,
              tileBuilder: widget.tileBuilder,
              childAspectRatio: widget.childAspectRatio,
              disablePagination: widget.disablePagination,
              scrollDirection: widget.scrollDirection,
              emptyListWidget: widget.emptyListWidget,
              onEmptyList: widget.onEmptyList,
            );
          default:
            return null;
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
  final Axis scrollDirection;
  final Widget emptyListWidget;
  final Function onEmptyList;

  const PaginatedGridView({
    Key key,
    @required this.data,
    @required this.filter,
    @required this.controller,
    @required this.gridCount,
    @required this.tileBuilder,
    this.childAspectRatio = 1,
    this.disablePagination,
    this.scrollDirection = Axis.vertical,
    this.emptyListWidget,
    this.onEmptyList,
  }) : super(key: key);

  @override
  _PaginatedGridViewState<I> createState() => _PaginatedGridViewState<I>();
}

class _PaginatedGridViewState<I> extends State<PaginatedGridView> {
  final ScrollController _scrollController = new ScrollController();
  LoadMoreStatus loadMoreStatus = LoadMoreStatus.STABLE;
  List<I> items = [];
  int currentPage;
  CancelableOperation itemOperation;

  @override
  void initState() {
    items = widget.data.items;
    currentPage = 1;
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    if (itemOperation != null) itemOperation.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if ((widget.onEmptyList != null) && (items.isEmpty)) widget.onEmptyList();
    return NotificationListener(
      onNotification: !(widget.disablePagination) ? onNotification : null,
      child: items.length != 0
          ? GridView.builder(
              shrinkWrap: widget.scrollDirection == Axis.vertical,
              scrollDirection: widget.scrollDirection,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.scrollDirection == Axis.vertical
                    ? widget.gridCount
                    : 1,
                childAspectRatio: widget.childAspectRatio,
              ),
              controller: _scrollController,
              itemCount: items.length,
              physics: ScrollPhysics(),
              itemBuilder: (_, index) => widget.tileBuilder(
                  context, items[index], index, onDelete, null),
            )
          : widget.emptyListWidget,
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

  // Future<bool> onDelete(int index) async {
  //   final item = items[index];
  //   return await widget.viewModel.deleteData(item);
  // }

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (_scrollController.position.maxScrollExtent >
              _scrollController.offset &&
          _scrollController.position.maxScrollExtent -
                  _scrollController.offset <=
              50) {
        if (loadMoreStatus != null && loadMoreStatus == LoadMoreStatus.STABLE) {
          Fimber.d(
              "calling again.................................................");
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
  final String text;
  const EmptyListWidget({
    Key key,
    this.text = "Fill Me Up!",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          verticalSpaceSmall,
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Image.asset("assets/images/empty_cart.png"),
            ),
          ),
        ],
      ),
    );
  }
}
