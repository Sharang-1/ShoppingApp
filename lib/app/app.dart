import 'package:compound/models/ordersV2.dart';

late App appVar;

class App {
  late List<Order> previousOrders;
  late List<Order> currentOrders;
  List<String> dynamicSectionKeys = [];
  static bool isUserLoggedIn = false;
  static bool isDeleteRequested = false;
  String devUrl = "https://dev.dzor.in/api/";
  String liveUrl = "https://www.dzor.in/api/";
  String currentUrl = "";
}

class DzorConst {
  num? promotedProduct;
}
