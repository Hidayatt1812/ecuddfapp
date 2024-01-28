import 'package:equatable/equatable.dart';

class Timing extends Equatable {
  final int id;
  final double tpsValue;
  final double mintpsValue;
  final double maxtpsValue;
  final double rpmValue;
  final double minrpmValue;
  final double maxrpmValue;
  final double value;

  const Timing({
    required this.id,
    required this.tpsValue,
    required this.mintpsValue,
    required this.maxtpsValue,
    required this.rpmValue,
    required this.minrpmValue,
    required this.maxrpmValue,
    required this.value,
  });

  const Timing.empty()
      : id = 0,
        tpsValue = 0,
        mintpsValue = 0,
        maxtpsValue = 0.5,
        rpmValue = 0,
        minrpmValue = 0,
        maxrpmValue = 0.5,
        value = 0;

  @override
  List<Object?> get props => [
        id,
        tpsValue,
        mintpsValue,
        maxtpsValue,
        rpmValue,
        minrpmValue,
        maxrpmValue,
        value,
      ];

  @override
  String toString() {
    return 'Timing{id: $id,'
        'tpsValue: $tpsValue, mintpsValue: $mintpsValue, maxtpsValue: $maxtpsValue,'
        'rpmValue: $rpmValue, minrpmValue: $minrpmValue, maxrpmValue: $maxrpmValue,'
        'value: $value}';
  }
}
