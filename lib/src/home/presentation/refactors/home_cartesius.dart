import 'dart:math';

import 'package:ddfapp/core/common/app/providers/cartesius_provider.dart';
import 'package:ddfapp/core/res/fonts.dart';
import 'package:ddfapp/src/home/presentation/widgets/cartesius_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/res/colours.dart';

class HomeCartesius extends StatefulWidget {
  const HomeCartesius({super.key});

  @override
  State<HomeCartesius> createState() => _HomeCartesiusState();
}

class _HomeCartesiusState extends State<HomeCartesius> {
  @override
  Widget build(BuildContext context) {
    // double xMinAxis = 0;
    // double xMaxAxis = 9;
    // int xAxis = 20;
    // double xInterval = (xMaxAxis - xMinAxis) / (xAxis - 1);

    // double yMinAxis = 0;
    // double yMaxAxis = 14;
    // int yAxis = 20;
    // double yInterval = (yMaxAxis - yMinAxis) / (yAxis - 1);

    // List<int> list =
    //     List.generate(xAxis * yAxis, (index) => Random().nextInt(100) + 1);

    return Consumer<CartesiusProvider>(
      builder: (_, cartesiusProvider, __) {
        return Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.all(10),
          width: 1060,
          height: 500,
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
                            values: (List.generate(
                                    cartesiusProvider.rpm.steps,
                                    (index) =>
                                        cartesiusProvider.rpm.minValue +
                                        index * cartesiusProvider.rpm.interval))
                                .reversed
                                .toList(),
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
                          values: List.generate(
                            cartesiusProvider.tps.steps,
                            (index) =>
                                cartesiusProvider.tps.minValue +
                                index * cartesiusProvider.tps.interval,
                          ),
                          direction: Axis.horizontal,
                        ),
                      ),
                      SizedBox.fromSize(
                        size: Size(parentWidth - size, parentHeight - size),
                        child: Column(
                          children: [
                            for (double j = cartesiusProvider.rpm.maxValue;
                                j >= cartesiusProvider.rpm.minValue;
                                j -= cartesiusProvider.rpm.interval)
                              Row(
                                children: [
                                  for (double i =
                                          cartesiusProvider.tps.minValue;
                                      i <= cartesiusProvider.tps.maxValue;
                                      i += cartesiusProvider.tps.interval)
                                    SizedBox(
                                      width: (parentWidth - size) /
                                          cartesiusProvider.tps.steps,
                                      height: (parentHeight - size) /
                                          cartesiusProvider.rpm.steps,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                        ),
                                        elevation: 0,
                                        margin: const EdgeInsets.all(0),
                                        color: Colours.primaryColour,
                                        surfaceTintColor: Colours.primaryColour,
                                        child: InkWell(
                                          onTap: () {
                                            // debugPrint(
                                            //     'index: ${(j - 1) * xAxis + (i - 1)}');
                                            // debugPrint(
                                            //     'value: ${list[(j - 1) * xAxis + (i - 1)]}');
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
                                            child: const Center(
                                              child: Text(
                                                // '${list[(j - 1) * xAxis + (i - 1)]}',
                                                '1',
                                                style: TextStyle(
                                                  fontFamily: Fonts.segoe,
                                                  fontSize: 10,
                                                  color:
                                                      Colours.onPrimaryColour,
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
      },
    );
  }
}
