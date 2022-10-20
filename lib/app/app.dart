import 'package:compound/models/orders.dart';

late App appVar;

class App {
  late List<Order> previousOrders;
  late List<Order> currentOrders;
  List<String> dynamicSectionKeys = [];

  String devUrl = "https://dev.dzor.in/api/";
  String liveUrl = "https://www.dzor.in/api/";
  String currentUrl = "";
}

class DzorConst {
  num? promotedProduct;
}
