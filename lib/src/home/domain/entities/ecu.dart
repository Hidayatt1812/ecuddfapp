import 'package:equatable/equatable.dart';

class ECU extends Equatable {
  final double tps;
  final double rpm;
  final double map;
  final double temp1;
  final double temp2;
  final double temp3;
  final double timing1;
  final double timing2;
  final double timing3;
  final double timing4;
  final bool powerStatus;

  const ECU({
    required this.tps,
    required this.rpm,
    required this.map,
    required this.temp1,
    required this.temp2,
    required this.temp3,
    required this.timing1,
    required this.timing2,
    required this.timing3,
    required this.timing4,
    required this.powerStatus,
  });

  const ECU.empty()
      : tps = 0,
        rpm = 0,
        map = 0,
        temp1 = 0,
        temp2 = 0,
        temp3 = 0,
        timing1 = 0,
        timing2 = 0,
        timing3 = 0,
        timing4 = 0,
        powerStatus = false;

  @override
  List<Object?> get props => [
        tps,
        rpm,
        map,
        temp1,
        temp2,
        temp3,
        timing1,
        timing2,
        timing3,
        timing4,
        powerStatus,
      ];

  @override
  String toString() {
    return 'ECU{tps: $tps, rpm: $rpm, map: $map, temp1: $temp1,'
        'temp2: $temp2, temp3: $temp3,'
        'timing1: $timing1, timing2: $timing2, timing3: $timing3,'
        'timing4: $timing4, powerStatus: $powerStatus}';
  }
}
