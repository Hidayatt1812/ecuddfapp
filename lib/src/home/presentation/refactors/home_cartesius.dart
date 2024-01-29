import 'dart:math';

import 'package:ddfapp/core/res/fonts.dart';
import 'package:ddfapp/src/home/presentation/widgets/cartesius_header.dart';
import 'package:flutter/material.dart';

import '../../../../core/res/colours.dart';

class HomeCartesius extends StatefulWidget {
  const HomeCartesius({super.key});

  @override
  State<HomeCartesius> createState() => _HomeCartesiusState();
}

class _HomeCartesiusState extends State<HomeCartesius> {
  @override
  Widget build(BuildContext context) {
    int xAxis = 35;
    int yAxis = 20;
    List<int> list =
        List.generate(xAxis * yAxis, (index) => Random().nextInt(100) + 1);
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(10),
      width: 1060,
      height: 450,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            offset: const Offset(-6.0, -6.0),
            blurRadius: 16.0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(6.0, 6.0),
            blurRadius: 16.0,
          ),
        ],
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double parentWidth = constraints.maxWidth;
          double parentHeight = constraints.maxHeight;
          double size = 64;
          return Row(
            children: [
              Column(
                children: [
                  SizedBox.fromSize(
                    size: Size(size, size),
                  ),
                  SizedBox.fromSize(
                      size: Size(size, parentHeight - size),
                      child: CartesiusHeader(
                        title: 'RPM',
                        size: Size(size, parentHeight - size),
                        values:
                            List.generate(yAxis, (index) => index.toDouble()),
                        direction: Axis.vertical,
                      )),
                ],
              ),
              Column(
                children: [
                  SizedBox.fromSize(
                    size: Size(parentWidth - size, size),
                    child: CartesiusHeader(
                      title: 'THROTTLE (mV)',
                      size: Size(parentWidth - size, size),
                      values: List.generate(xAxis, (index) => index.toDouble()),
                      direction: Axis.horizontal,
                    ),
                  ),
                  SizedBox.fromSize(
                    size: Size(parentWidth - size, parentHeight - size),
                    child: Column(
                      children: [
                        for (int j = yAxis; j > 0; j--)
                          Row(
                            children: [
                              for (int i = 1; i <= xAxis; i++)
                                SizedBox(
                                  width: (parentWidth - size) / xAxis,
                                  height: (parentHeight - size) / yAxis,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    elevation: 0,
                                    margin: const EdgeInsets.all(0),
                                    color: Colours.primaryColour,
                                    surfaceTintColor: Colours.primaryColour,
                                    child: InkWell(
                                      onTap: () {
                                        debugPrint(
                                            'index: ${(j - 1) * xAxis + (i - 1)}');
                                        debugPrint(
                                            'value: ${list[(j - 1) * xAxis + (i - 1)]}');
                                      },
                                      hoverColor: Colours.secondaryColour,
                                      hoverDuration:
                                          const Duration(milliseconds: 200),
                                      radius: 10,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colours.onPrimaryColour,
                                            width: 0.5,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${list[(j - 1) * xAxis + (i - 1)]}',
                                            style: const TextStyle(
                                              fontFamily: Fonts.segoe,
                                              fontSize: 10,
                                              color: Colours.onPrimaryColour,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
