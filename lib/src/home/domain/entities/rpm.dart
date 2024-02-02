import 'package:equatable/equatable.dart';

class RPM extends Equatable {
  final int id;
  final bool isFirst;
  final bool isLast;
  final double value;
  final double? prevValue;
  final double? nextValue;

  const RPM({
    required this.id,
    required this.isFirst,
    required this.isLast,
    required this.value,
    required this.prevValue,
    required this.nextValue,
  });

  const RPM.empty()
      : id = 0,
        isFirst = true,
        isLast = true,
        value = 0,
        prevValue = null,
        nextValue = null;

  @override
  List<Object?> get props => [
        id,
        isFirst,
        isLast,
        value,
        prevValue,
        nextValue,
      ];

  @override
  String toString() {
    return 'RPM{id: $id, isFirst: $isFirst, isLast: $isLast, value: $value,'
        'prevValue: $prevValue, nextValue: $nextValue }';
  }
}
