import 'package:compound/locator.dart';
import 'package:compound/models/reviews.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/viewmodels/base_model.dart';

class ReviewsViewModel extends BaseModel {
  final APIService _apiService = locator<APIService>();
  Reviews reviews;
  bool isBusyWritingReview = false;
  bool isFormVisible = false;

  void toggleFormVisibility() {
    isFormVisible = !isFormVisible;
    notifyListeners();
  }

  Future showReviews(String productId) async {
    setBusy(true);
    reviews = await _apiService.getReviews(productId, isSellerReview: false);
    setBusy(false);
  }

  Future writeReiew(String key, double ratings, String description,
      {isSellerReview = false}) async {
    isBusyWritingReview = true;
    notifyListeners();

    var _ = await _apiService.postReview(key, ratings, description,
        isSellerReview: isSellerReview);

    isBusyWritingReview = false;
    toggleFormVisibility();
    notifyListeners();
  }
}
