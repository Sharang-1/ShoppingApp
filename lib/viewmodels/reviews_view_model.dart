import 'package:compound/locator.dart';
import 'package:compound/models/reviews.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/viewmodels/base_model.dart';

class ReviewsViewModel extends BaseModel {
  final APIService _apiService = locator<APIService>();
  Reviews reviews;

  Future showReviews(String productId) async {
    setBusy(true);
    reviews = await _apiService.getReviews(productId: productId);
    setBusy(false);
  }
}
