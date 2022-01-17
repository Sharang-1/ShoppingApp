import '../locator.dart';
import '../models/reviews.dart';
import '../models/sellers.dart';
import 'api/api_service.dart';

class CacheService {
  List<Seller>? sellers = [];
  Map<String, Reviews> productReviews = {};
  Map<String, Reviews> sellerReviews = {};
  bool busy = false;

  Future<List<Seller>?> getSellers() async {
    while (busy) {
      await Future.delayed(Duration(milliseconds: 500));
    }
    if ((sellers ?? []).isEmpty) {
      busy = true;
      sellers =
          (await locator<APIService>().getSellers(queryString: "limit=1000;"))
              .items;
      if ((sellers ?? []).isEmpty) {
        sellers =
            (await locator<APIService>().getSellers(queryString: "limit=1000;"))
                .items;
      }
      busy = false;
    }
    return sellers;
  }

  void addReviews(String id, Reviews r, {isSeller = false}) {
    (isSeller ? sellerReviews : productReviews).addAll({
      id: r,
    });
  }

  Reviews? getReviews(String id, {isSeller = false}) {
    var r = (isSeller ? sellerReviews : productReviews)[id];
    return r;
  }
}
