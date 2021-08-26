import 'package:fimber/fimber_base.dart';

import '../locator.dart';
import '../models/sellers.dart';
import 'api/api_service.dart';

class CacheService {
  List<Seller> sellers = [];
  bool busy = false;

  Future<List<Seller>> getSellers() async {
    while (busy) {
      await Future.delayed(Duration(milliseconds: 500));
    }
    if ((sellers ?? []).isEmpty) {
      busy = true;
      sellers =
          (await locator<APIService>().getSellers(queryString: "limit=1000;"))
              ?.items;
      if ((sellers ?? []).isEmpty) {
        sellers =
            (await locator<APIService>().getSellers(queryString: "limit=1000;"))
                ?.items;
      }
      busy = false;
      Fimber.i("Cache Designers: ${sellers?.length}");
    }
    return sellers;
  }
}
