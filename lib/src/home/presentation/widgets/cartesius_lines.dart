import 'package:flutter/material.dart';

class CartesiusLines extends StatelessWidget {
  const CartesiusLines({
    super.key,
    required this.size,
    required this.color,
    required this.direction,
    required this.value,
  });

  final Size size;
  final Color color;
  final Axis direction;
  final double value;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: SizedBox.fromSize(
        size: size,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            margin: direction == Axis.horizontal
                ? EdgeInsets.only(left: value * constraints.maxWidth)
                : EdgeInsets.only(bottom: value * constraints.maxHeight),
            decoration: BoxDecoration(
              border: direction == Axis.horizontal
                  ? Border(
                      left: BorderSide(
                        color: color,
                        width: 2,
                      ),
                    )
                  : Border(
                      bottom: BorderSide(
                        color: color,
                        width: 2,
                      ),
                    ),
            ),
          );
        }),
      ),
    );
  }
}
