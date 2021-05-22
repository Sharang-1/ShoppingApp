import 'package:get/state_manager.dart';

import '../locator.dart';
import '../models/reviews.dart';
import '../services/api/api_service.dart';
import 'base_controller.dart';

class ReviewsController extends BaseController {
  final APIService _apiService = locator<APIService>();
  Reviews reviews;
  RxBool isBusyWritingReview = false.obs;
  RxBool isFormVisible = false.obs;

  String id;
  bool isSeller;

  ReviewsController({this.id, this.isSeller = false});

  @override
  void onInit() async {
    super.onInit();
    if (id != null) {
      setBusy(true);
      reviews =
          await _apiService.getReviews(id, isSellerReview: isSeller);
      setBusy(false);
      update();
    }
  }

  void toggleFormVisibility() {
    isFormVisible.value = !isFormVisible.value;
  }

  Future writeReiew(String key, double ratings, String description,
      {isSellerReview = false}) async {
    isBusyWritingReview.value = true;

    var _ = await _apiService.postReview(key, ratings, description,
        isSellerReview: isSellerReview);

    isBusyWritingReview.value = false;
    toggleFormVisibility();
  }
}