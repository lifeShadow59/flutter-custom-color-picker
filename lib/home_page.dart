import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:color_picker/color_list.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);
  final HomePageConroller _homePageConroller = Get.put(HomePageConroller());
  @override
  Widget build(BuildContext context) {
    _homePageConroller.screenWidth = MediaQuery.of(context).size.width;
    return Material(
      color: Colors.amber,
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 200,
            ),
            GetBuilder<HomePageConroller>(
              id: "colorText",
              builder: (HomePageConroller controller) {
                return Text(
                  "Color ${colorList[controller.selectedColorIndex]}",
                  style: TextStyle(
                    color: colorList[controller.selectedColorIndex],
                    fontSize: 24,
                  ),
                );
              },
            ),
            const SizedBox(
              height: 100,
            ),
            GestureDetector(
              onPanUpdate: (DragUpdateDetails dragStartDetails) {
                final screenHarfWidth = _homePageConroller.screenWidth / 2;
                final double dxPosition = dragStartDetails.localPosition.dx;
                if (screenHarfWidth > dxPosition) {
                  final double ponterDxValue = dxPosition - screenHarfWidth;
                  _homePageConroller.xPointer =
                      (ponterDxValue / screenHarfWidth);
                  _calculateColor(dxPosition);
                } else if (screenHarfWidth < dxPosition) {
                  final double ponterDxValue = dxPosition - screenHarfWidth;
                  _homePageConroller.xPointer = ponterDxValue / screenHarfWidth;
                  _calculateColor(dxPosition);
                } else {
                  _homePageConroller.xPointer = 0;
                  _calculateColor(dxPosition);
                }

                _homePageConroller.update(['colorPelet', 'colorText']);
              },
              child: GetBuilder<HomePageConroller>(
                id: "colorPelet",
                builder: (HomePageConroller controller) {
                  return Stack(
                    alignment: Alignment(controller.xPointer, 0),
                    children: [
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: colorList,
                          ),
                        ),
                      ),
                      Container(
                        height: 70,
                        width: 10,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: colorList,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _calculateColor(double value) {
    final double sacreenTouch = (value * 100) / _homePageConroller.screenWidth;

    _homePageConroller.selectedColorIndex = ((256 * sacreenTouch) ~/ 100) - 1;
  }
}

class HomePageConroller extends GetxController {
  double screenWidth = 0.0;
  double xPointer = 0.0;
  int selectedColorIndex = 128;
}
