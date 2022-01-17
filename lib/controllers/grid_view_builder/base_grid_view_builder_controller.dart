import '../../models/grid_view_builder_filter_models/base_filter_model.dart';
import '../base_controller.dart';

abstract class BaseGridViewBuilderController<T, I> extends BaseController {
  Future init();
  Future<T> getData(
      {required BaseFilterModel filterModel,
      required int pageNumber,
      int pageSize = 10});
  Future<bool> deleteData(I item) {
    return Future.value(false);
  }
}
