import 'dart:math';

import 'package:ddfapp/core/res/colours.dart';
import 'package:ddfapp/core/res/fonts.dart';
import 'package:ddfapp/core/utils/core_utils.dart';
import 'package:flutter/material.dart';

class CartesiusHeader extends StatelessWidget {
  const CartesiusHeader({
    super.key,
    required this.title,
    this.direction = Axis.horizontal,
    this.values = const [0],
    required this.size,
  });
  final Axis direction;
  final String title;
  final List<double> values;
  final Size size;
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
              quarterTurns: direction == Axis.horizontal ? 0 : 1,
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
                    dynamic value = CoreUtils.intOrDouble(values[index]);
                    return Container(
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
