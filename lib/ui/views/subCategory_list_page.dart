import 'package:flutter/material.dart';

import '../../constants/route_names.dart';
import '../../models/categorys.dart';
import '../../models/productPageArg.dart';
import '../../services/navigation_service.dart';
// import '../widgets/categoryTileUI.dart';

class SubCategoryIndiView extends StatelessWidget {
  final RootCategory category;
  String address;

  SubCategoryIndiView({required this.category, required this.address});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            SizedBox(height: 10),
            Text(address,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const BackButton(
          color: Colors.black54,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
          itemCount: category.children!.length,
          itemBuilder: (context, index) {
            if (category.children![index].forApp == false) {
              return Container();
            }
            return Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: InkWell(
                  onTap: () {
                    if (category.children![index].children != null) {
                      NavigationService.to(SubCategoryIndiViewRoute,
                          arguments: CategoryPageArg(
                            address: "${category.children![index].name}",
                            subCategory: category.children![index],
                          ));
                    } else {
                      NavigationService.to(CategoryIndiViewRoute,
                          arguments: ProductPageArg(
                            queryString: category.children![index].filter,
                            subCategory: category.children![index].name,
                          ));
                    }
                  },
                  child: Row(children: [
                    Expanded(
                      child: Text(
                        category.children![index].name!,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (category.children![index].children != null)
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black54,
                        size: 18,
                      ),
                  ]),
                ));
          },
        ),
      ),
    ));
  }
  // @override
  // Widget build(BuildContext context) {
  //   return SafeArea(
  //     child: Scaffold(
  //       appBar: AppBar(
  //         title: Text("Categories",
  //             style: TextStyle(
  //               color: Colors.black,
  //               fontSize: 22,
  //               fontWeight: FontWeight.bold,
  //             )),
  //         centerTitle: true,
  //         elevation: 0,
  //         backgroundColor: Colors.transparent,
  //         leading: const BackButton(
  //           color: Colors.black,
  //         ),
  //       ),
  //       body: Container(
  //         padding: EdgeInsets.symmetric(horizontal: 16.0),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             SizedBox(height: 10),
  //             Align(
  //               alignment: Alignment.centerLeft,
  //               child: Text(address,
  //                   style: TextStyle(
  //                     color: Colors.black,
  //                     fontSize: 15,
  //                   )),
  //             ),
  //             SizedBox(height: 5),
  //             Flexible(
  //               child: ListView.builder(
  //                 itemCount: category.children!.length,
  //                 itemBuilder: (context, index) {
  //                   return Padding(
  //                     padding: EdgeInsets.symmetric(vertical: 16.0),
  //                     child: NewCategoryTile(
  //                       data: category.children![index],
  //                       fromCategory: false,
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
