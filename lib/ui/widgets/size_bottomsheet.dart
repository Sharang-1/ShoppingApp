import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/bottomsheet_size_controller.dart';
import '../shared/app_colors.dart';
import '../shared/ui_helpers.dart';
import 'custom_text.dart';

class SizeBottomsheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomsheetSizeController>(
      init: BottomsheetSizeController()..init(),
      builder: (controller) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: Get.size.height * 0.8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: Colors.white,
              ),
              padding: EdgeInsets.only(
                top: 8.0,
                left: 16.0,
                right: 16.0,
                bottom: MediaQuery.of(context).padding.bottom,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    verticalSpaceSmall,
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Center(
                        child: CustomText(
                          "Help Us Serve You Better !!",
                          isBold: true,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    verticalSpaceSmall,
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Center(
                        child: CustomText(
                          "Make your shopping easier. Set your sizes ✌️😄",
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    verticalSpaceSmall,
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/measurements.png",
                          height: Get.height / 2,
                        ),
                        horizontalSpaceMedium,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getSizeWidget(
                              hint: "*Shoulder",
                              focusNode: controller.size1Focus,
                              controller: controller.size1Controller,
                            ),
                            verticalSpaceTiny,
                            getSizeWidget(
                              hint: "*Chest",
                              focusNode: controller.size2Focus,
                              controller: controller.size2Controller,
                            ),
                            verticalSpaceTiny,
                            getSizeWidget(
                              hint: "*Waist",
                              focusNode: controller.size3Focus,
                              controller: controller.size3Controller,
                            ),
                            verticalSpaceTiny,
                            getSizeWidget(
                              hint: "*Hips",
                              focusNode: controller.size4Focus,
                              controller: controller.size4Controller,
                            ),
                            verticalSpaceTiny,
                            getSizeWidget(
                              hint: "*Height",
                              focusNode: controller.size5Focus,
                              controller: controller.size5Controller,
                            ),
                            verticalSpaceSmall,
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "*In inches.",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: 10.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    verticalSpaceSmall,
                    Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: ElevatedButton(
                            onPressed: controller.submit,
                            style: ElevatedButton.styleFrom(
                              primary: lightGreen,
                              onPrimary: Colors.white,
                              elevation: 0,
                            ),
                            child: Text("Continue To Bag"),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: ElevatedButton(
                            onPressed: controller.skip,
                            style: ElevatedButton.styleFrom(
                              onPrimary: Colors.black,
                              primary: Colors.white,
                              elevation: 0,
                            ),
                            child: Text("Skip"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  getSizeWidget(
          {@required FocusNode focusNode,
          @required TextEditingController controller,
          @required String hint}) =>
      SizedBox(
        width: 120,
        child: Row(
          children: [
            Expanded(
              child: CustomText(
                hint,
                fontSize: 10,
                color: Colors.grey[500],
              ),
            ),
            Expanded(
              child: TextField(
                focusNode: focusNode,
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
                ),
              ),
            ),
          ],
        ),
      );
}
