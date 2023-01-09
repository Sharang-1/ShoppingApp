import 'package:compound/models/groupOrderModel.dart';

class GroupOrderData {
  static List<GroupOrderModel> cartProducts = [];
  static List<GroupOrderCostEstimateModel> cartEstimateItems = [];
  static List<String> sellersList = [];
  static double orderTotal = 0.0;
}
