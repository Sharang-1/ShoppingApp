import 'package:async/async.dart';
import 'package:compound/models/grid_view_builder_filter_models/base_filter_model.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/viewmodels/grid_view_builder_view_models/base_grid_view_builder_view_model.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider_architecture/provider_architecture.dart';

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
  final BaseGridViewBuilderViewModel viewModel;
  final TileFunctionBuilder tileBuilder;
  final int gridCount;
  final double childAspectRatio;
  final bool disablePagination;

  const GridListWidget({
    Key key,
    @required this.context,
    @required this.filter,
    @required this.viewModel,
    @required this.gridCount,
    @required this.tileBuilder,
    this.childAspectRatio = 1.0,
    this.disablePagination = false,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<BaseGridViewBuilderViewModel>.withConsumer(
      viewModel: viewModel,
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => filter != null
          ? CustomGridViewFutureBuilder<P, I>(
              filter: filter,
              gridCount: gridCount,
              tileBuilder: tileBuilder,
              model: model,
              childAspectRatio: childAspectRatio,
              disablePagination: disablePagination)
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
    @required this.model,
    this.childAspectRatio = 1.0,
    this.disablePagination,
  }) : super(key: key);

  final BaseFilterModel filter;
  final int gridCount;
  final TileFunctionBuilder tileBuilder;
  final BaseGridViewBuilderViewModel model;
  final double childAspectRatio;
  final bool disablePagination;

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
    print("------------------------------------------------------");
    print(widget.filter);
    print("------------------------------------------------------");
    filter = widget.filter;
    future = widget.model.getData(
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
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            print("snapshots.data");
            print(snapshots.data);
            return PaginatedGridView<P, I>(
              data: snapshots.data,
              filter: widget.filter,
              viewModel: widget.model,
              gridCount: widget.gridCount,
              tileBuilder: widget.tileBuilder,
              childAspectRatio: widget.childAspectRatio,
              disablePagination: widget.disablePagination,
            );
          default:
            return null;
        }
      },
    );
  }
}

class PaginatedGridView<P, I> extends StatefulWidget {
  final BaseGridViewBuilderViewModel viewModel;
  final P data;
  final BaseFilterModel filter;
  final TileFunctionBuilder tileBuilder;
  final int gridCount;
  final double childAspectRatio;
  final bool disablePagination;

  const PaginatedGridView({
    Key key,
    @required this.data,
    @required this.filter,
    @required this.viewModel,
    @required this.gridCount,
    @required this.tileBuilder,
    this.childAspectRatio = 1,
    this.disablePagination,
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
    return NotificationListener(
      onNotification: !(widget.disablePagination) ? onNotification : null,
      child: items.length != 0
          ? GridView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.gridCount,
                childAspectRatio: widget.childAspectRatio,
              ),
              controller: _scrollController,
              itemCount: items.length,
              physics: ScrollPhysics(),
              itemBuilder: (_, index) => widget.tileBuilder(
                  context, items[index], index, onDelete, null),
            )
          : Center(
              child: Column(children: <Widget>[
              Text("No Products Found!"),
              verticalSpaceSmall,
              Image.asset("assets/images/empty_cart.png"),
            ])),
    );
  }

  Future<bool> onDelete(int index) async {
    print("Current ID::::: " + index.toString());
    final item = items[index];
    print("Current Item");
    print(item);
    final res = await widget.viewModel.deleteData(item);
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
          itemOperation = CancelableOperation.fromFuture(widget.viewModel
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
