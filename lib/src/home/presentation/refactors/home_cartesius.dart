import 'package:ddfapp/core/common/app/providers/cartesius_provider.dart';
import 'package:ddfapp/core/res/fonts.dart';
import 'package:ddfapp/src/home/presentation/bloc/home_bloc.dart';
import 'package:ddfapp/src/home/presentation/widgets/cartesius_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/widgets/main_pop_up.dart';
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
                            values: cartesiusProvider.rpms,
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
                          values: cartesiusProvider.tpss,
                          direction: Axis.horizontal,
                        ),
                      ),
                      SizedBox.fromSize(
                        size: Size(parentWidth - size, parentHeight - size),
                        child: Column(
                          children: [
                            for (int j = cartesiusProvider.rpms.length - 1;
                                j >= 0;
                                j--)
                              Row(
                                children: [
                                  for (int i = 0;
                                      i < cartesiusProvider.tpss.length;
                                      i++)
                                    SizedBox(
                                      width: (parentWidth - size) /
                                          cartesiusProvider.tpss.length,
                                      height: (parentHeight - size) /
                                          cartesiusProvider.rpms.length,
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
                                          onHover: (value) {
                                            if (value &&
                                                cartesiusProvider
                                                    .isSelectingTiming) {
                                              cartesiusProvider.setIdEndTiming(
                                                  cartesiusProvider
                                                      .timings[j *
                                                              cartesiusProvider
                                                                  .tpss.length +
                                                          i]
                                                      .id);
                                            }
                                          },
                                          onDoubleTap: () {
                                            if (!cartesiusProvider
                                                .isSelectingTiming) {
                                              cartesiusProvider
                                                  .setIsSelectingTiming(true);
                                              cartesiusProvider.setIdStartTiming(
                                                  cartesiusProvider
                                                      .timings[j *
                                                              cartesiusProvider
                                                                  .tpss.length +
                                                          i]
                                                      .id);
                                            } else {
                                              cartesiusProvider
                                                  .setIsSelectingTiming(false);
                                              cartesiusProvider
                                                  .setIdStartTiming(null);
                                              showDialog(
                                                context: context,
                                                builder: (_) {
                                                  final TextEditingController
                                                      controller =
                                                      TextEditingController();
                                                  return MainPopUp(
                                                    title: 'Timing',
                                                    data: cartesiusProvider
                                                        .idsTimings,
                                                    controller: controller,
                                                    onPressed: () {
                                                      if (controller
                                                          .text.isNotEmpty) {
                                                        context
                                                            .read<HomeBloc>()
                                                            .add(
                                                                SetTimingManuallyEvent(
                                                              ids: cartesiusProvider
                                                                  .idsTimings,
                                                              timings:
                                                                  cartesiusProvider
                                                                      .timings,
                                                              value:
                                                                  double.parse(
                                                                      controller
                                                                          .text),
                                                            ));
                                                        cartesiusProvider
                                                            .resetIdsTiming();
                                                        Navigator.of(context)
                                                            .pop();
                                                      }

                                                      controller.dispose();
                                                    },
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          onTap: () {
                                            debugPrint(
                                                'index: ${cartesiusProvider.timings[j * cartesiusProvider.tpss.length + i].id}');
                                            debugPrint(
                                                'TPSValue: ${cartesiusProvider.timings[j * cartesiusProvider.tpss.length + i].tpsValue}');
                                            debugPrint(
                                                'minTPSValue: ${cartesiusProvider.timings[j * cartesiusProvider.tpss.length + i].mintpsValue}');
                                            debugPrint(
                                                'maxTPSValue: ${cartesiusProvider.timings[j * cartesiusProvider.tpss.length + i].maxtpsValue}');
                                            debugPrint(
                                                'RPMValue: ${cartesiusProvider.timings[j * cartesiusProvider.tpss.length + i].rpmValue}');
                                            debugPrint(
                                                'minRPMValue: ${cartesiusProvider.timings[j * cartesiusProvider.tpss.length + i].minrpmValue}');
                                            debugPrint(
                                                'maxRPMValue: ${cartesiusProvider.timings[j * cartesiusProvider.tpss.length + i].maxrpmValue}');
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
                                              color: cartesiusProvider
                                                      .idsTimings
                                                      .contains(cartesiusProvider
                                                          .timings[j *
                                                                  cartesiusProvider
                                                                      .tpss
                                                                      .length +
                                                              i]
                                                          .id)
                                                  ? Colours.secondaryColour
                                                  : Colours.primaryColour,
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${cartesiusProvider.timings[j * 10 + i].value}',
                                                style: const TextStyle(
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
