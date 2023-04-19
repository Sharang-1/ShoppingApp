import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/route_names.dart';
import '../../locator.dart';
import '../../models/categorys.dart';
import '../../models/productPageArg.dart';
import '../../services/api/api_service.dart';
import '../../services/navigation_service.dart';
import '../widgets/categoryTileUI.dart';
import '../widgets/shimmer/shimmer_widget.dart';

class CategoryListPage extends StatelessWidget {
  final APIService _apiService = locator<APIService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Categories',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            FutureBuilder(
              future: _apiService.getRootCategory(),
              builder: (context, AsyncSnapshot<RootCategory> snapshot) {
                if (snapshot.hasData) {
                  return Flexible(
                    child: ListView.builder(
                      itemCount: snapshot.data!.children!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            // child: NewCategoryTile(
                            //   data: snapshot.data!.children![index],
                            //   fromCategory: false,
                            // ),
                            child: InkWell(
                              onTap: () {
                                NavigationService.to(SubCategoryIndiViewRoute,
                                    arguments: CategoryPageArg(
                                      address:
                                          "${snapshot.data!.children![index].name}",
                                      subCategory:
                                          snapshot.data!.children![index],
                                    ));
                              },
                              child: Row(children: [
                                Expanded(
                                  child: Text(
                                    snapshot.data!.children![index].name!,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios),
                              ]),
                            ));
                      },
                    ),
                  );
                } else {
                  return Container(
                      height: Get.size.height * 0.68, child: ShimmerWidget());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
