import 'package:flutter/material.dart';

class CartesiusLines extends StatelessWidget {
  const CartesiusLines(
      {super.key,
      required this.size,
      required this.controller,
      required this.color,
      required this.direction});

  final Size size;
  final AnimationController controller;
  final Color color;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: SizedBox.fromSize(
        size: size,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          Animation<double> _animation = Tween<double>(
            begin: 0.0,
            end: direction == Axis.horizontal
                ? constraints.maxWidth
                : constraints.maxHeight,
          ).animate(controller);
          return AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                margin: direction == Axis.horizontal
                    ? EdgeInsets.only(right: _animation.value)
                    : EdgeInsets.only(top: _animation.value),
                decoration: BoxDecoration(
                  border: direction == Axis.horizontal
                      ? Border(
                          right: BorderSide(
                            color: color,
                            width: 2,
                          ),
                        )
                      : Border(
                          top: BorderSide(
                            color: color,
                            width: 2,
                          ),
                        ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
