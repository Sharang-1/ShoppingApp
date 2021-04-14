import '../locator.dart';
import '../models/reviews.dart';
import '../services/api/api_service.dart';
import 'base_model.dart';

class ReviewsViewModel extends BaseModel {
  final APIService _apiService = locator<APIService>();
  Reviews reviews;
  bool isBusyWritingReview = false;
  bool isFormVisible = false;

  void toggleFormVisibility() {
    isFormVisible = !isFormVisible;
    notifyListeners();
  }

  Future showReviews(String productId, {bool isSeller = false}) async {
    setBusy(true);
    reviews = await _apiService.getReviews(productId, isSellerReview: isSeller);
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
