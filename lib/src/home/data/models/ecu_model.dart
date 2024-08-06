import '../../../../core/utils/typedef.dart';
import '../../domain/entities/ecu.dart';

class ECUModel extends ECU {
  const ECUModel({
    required super.tps,
    required super.rpm,
    required super.map,
    required super.temp1,
    required super.temp2,
    required super.temp3,
    required super.timing1,
    required super.timing2,
    required super.timing3,
    required super.timing4,
    required super.powerStatus,
  });

  const ECUModel.empty()
      : this(
          tps: 0,
          rpm: 0,
          map: 0,
          temp1: 0,
          temp2: 0,
          temp3: 0,
          timing1: 0,
          timing2: 0,
          timing3: 0,
          timing4: 0,
          powerStatus: false,
        );

  ECUModel copyWith({
    double? tps,
    double? rpm,
    double? map,
    double? temp1,
    double? temp2,
    double? temp3,
    double? timing1,
    double? timing2,
    double? timing3,
    double? timing4,
    bool? powerStatus,
  }) {
    return ECUModel(
      tps: tps ?? this.tps,
      rpm: rpm ?? this.rpm,
      map: map ?? this.map,
      temp1: temp1 ?? this.temp1,
      temp2: temp2 ?? this.temp2,
      temp3: temp3 ?? this.temp3,
      timing1: timing1 ?? this.timing1,
      timing2: timing2 ?? this.timing2,
      timing3: timing3 ?? this.timing3,
      timing4: timing4 ?? this.timing4,
      powerStatus: powerStatus ?? this.powerStatus,
    );
  }

  ECUModel.fromMap(DataMap map)
      : super(
          tps: map['tps'],
          rpm: map['rpm'],
          map: map['map'],
          temp1: map['temp1'],
          temp2: map['temp2'],
          temp3: map['temp3'],
          timing1: map['timing1'],
          timing2: map['timing2'],
          timing3: map['timing3'],
          timing4: map['timing4'],
          powerStatus: map['powerStatus'],
        );

  DataMap toMap() {
    return {
      'tps': tps,
      'rpm': rpm,
      'map': map,
      'temp1': temp1,
      'temp2': temp2,
      'temp3': temp3,
      'timing1': timing1,
      'timing2': timing2,
      'timing3': timing3,
      'timing4': timing4,
      'powerStatus': powerStatus,
    };
  }
}
