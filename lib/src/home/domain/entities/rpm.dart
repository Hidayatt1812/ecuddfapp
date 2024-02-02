import 'package:equatable/equatable.dart';

class RPM extends Equatable {
  final int id;
  final double minValue;
  final double maxValue;
  final double interval;
  final int steps;
  final double value;

  const RPM({
    required this.id,
    required this.minValue,
    required this.maxValue,
    required this.interval,
    required this.steps,
    required this.value,
  });

  const RPM.empty()
      : id = 0,
        minValue = 0,
        maxValue = 9,
        interval = 1,
        steps = 10,
        value = 0;

  @override
  List<Object?> get props => [
        id,
        minValue,
        maxValue,
        interval,
        steps,
        value,
      ];

  @override
  String toString() {
    return 'RPM{id: $id, minValue: $minValue, maxValue: $maxValue,'
        'spaceValue: $interval, steps: $steps, value: $value}';
  }
}
