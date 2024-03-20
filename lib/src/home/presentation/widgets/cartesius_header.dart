import 'dart:math';

import 'package:ddfapp/core/res/colours.dart';
import 'package:ddfapp/core/res/fonts.dart';
import 'package:ddfapp/core/utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/app/providers/cartesius_provider.dart';
import '../../../../core/common/widgets/main_pop_up.dart';
import '../../domain/entities/rpm.dart';
import '../../domain/entities/tps.dart';

class CartesiusHeader extends StatelessWidget {
  const CartesiusHeader({
    super.key,
    required this.title,
    this.direction = Axis.horizontal,
    this.values = const [],
    this.multip = 1,
    required this.size,
  });
  final Axis direction;
  final String title;
  final List<dynamic> values;
  final Size size;
  final int multip;
  @override
  Widget build(BuildContext context) {
    double mines = 25;
    return Center(
      child: RotatedBox(
        quarterTurns: direction == Axis.horizontal ? 0 : 3,
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: Fonts.segoe,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            RotatedBox(
              quarterTurns: direction == Axis.horizontal ? 0 : 3,
              child: SizedBox(
                height: direction == Axis.horizontal
                    ? min(size.width, size.height) - mines
                    : size.height,
                width: direction == Axis.horizontal
                    ? size.width
                    : min(size.width, size.height) - mines,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: direction,
                  itemCount: values.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    dynamic value =
                        CoreUtils.intOrDouble(values[index].value * multip);
                    return GestureDetector(
                      onDoubleTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            final TextEditingController controller =
                                TextEditingController();
                            return MainPopUp(
                              title: 'Edit $title',
                              controller: controller,
                              value: '$value Voltage',
                              onPressedPositive: () {
                                if (values is List<TPS>) {
                                  if (controller.text.isNotEmpty) {
                                    context
                                        .read<CartesiusProvider>()
                                        .setTpsById(index,
                                            double.parse(controller.text));
                                    Navigator.of(context).pop();
                                  }
                                } else if (values is List<RPM>) {
                                  if (controller.text.isNotEmpty) {
                                    context
                                        .read<CartesiusProvider>()
                                        .setRpmById(index,
                                            double.parse(controller.text));
                                    Navigator.of(context).pop();
                                  }
                                }
                                controller.dispose();
                              },
                            );
                          },
                        );
                      },
                      child: RotatedBox(
                        quarterTurns: direction == Axis.horizontal ? 0 : 2,
                        child: Container(
                          width: direction == Axis.horizontal
                              ? (size.width) / values.length
                              : null,
                          height: direction == Axis.horizontal
                              ? null
                              : (size.height) / values.length,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colours.primaryColour,
                              width: 1,
                            ),
                            color: Colours.tertiaryColour,
                          ),
                          child: Center(
                            child: Text(
                              "$value",
                              style: const TextStyle(
                                fontFamily: Fonts.segoe,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: Colours.onTertiaryColour,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
