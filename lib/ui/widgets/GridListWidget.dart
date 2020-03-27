import 'package:async/async.dart';
import 'package:compound/models/grid_view_builder_filter_models/base_filter_model.dart';
import 'package:compound/viewmodels/grid_view_builder_view_models/base_grid_view_builder_view_model.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

// Type and Enum declarations
enum LoadMoreStatus { LOADING, STABLE }
typedef TileFunctionBuilder = Widget Function(
    BuildContext context, dynamic data);

class GridListWidget<P, I> extends StatelessWidget {
  final BaseFilterModel filter;
  final BaseGridViewBuilderViewModel viewModel;
  final TileFunctionBuilder tileBuilder;
  final int gridCount;

  const GridListWidget({
    Key key,
    @required this.context,
    @required this.filter,
    @required this.viewModel,
    @required this.gridCount,
    @required this.tileBuilder,
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
    @required this.model,
  }) : super(key: key);

  final BaseFilterModel filter;
  final int gridCount;
  final TileFunctionBuilder tileBuilder;
  final BaseGridViewBuilderViewModel model;

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
        if (snapshots.hasError) return Center(child: Text(snapshots.error));
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

  const PaginatedGridView({
    Key key,
    @required this.data,
    @required this.filter,
    @required this.viewModel,
    @required this.gridCount,
    @required this.tileBuilder,
  }) : super(key: key);

  @override
  _PaginatedGridViewState<I> createState() => _PaginatedGridViewState<I>();
}

class _PaginatedGridViewState<I> extends State<PaginatedGridView> {
  final ScrollController _scrollController = new ScrollController();
  LoadMoreStatus loadMoreStatus = LoadMoreStatus.STABLE;
  List<I> items;
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
      onNotification: onNotification,
      child: items.length != 0
          ? GridView.builder(
              padding: EdgeInsets.only(
                top: 5.0,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              controller: _scrollController,
              itemCount: items.length,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (_, index) =>
                  widget.tileBuilder(context, items[index]),
            )
          : Center(
              child: Text("No Items found"),
            ),
    );
  }

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
