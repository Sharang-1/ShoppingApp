import 'package:compound/models/grid_view_builder_filter_models/base_filter_model.dart';
import 'package:flutter/material.dart';

abstract class BaseGridViewBuilderViewModel<T> extends ChangeNotifier {
  Future init();
  Future<T> getData({BaseFilterModel filterModel, int pageNumber, int pageSize = 10});
}