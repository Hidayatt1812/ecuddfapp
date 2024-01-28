import '../../../../core/utils/typedef.dart';
import '../../domain/entities/rpm.dart';

class RPMModel extends RPM {
  const RPMModel({
    required super.id,
    required super.minValue,
    required super.maxValue,
    required super.spaceValue,
    required super.steps,
    required super.value,
  });

  const RPMModel.empty()
      : this(
          id: 0,
          minValue: 0,
          maxValue: 9,
          spaceValue: 1,
          steps: 10,
          value: 0,
        );

  RPMModel copyWith({
    int? id,
    double? minValue,
    double? maxValue,
    double? spaceValue,
    int? steps,
    double? value,
  }) {
    return RPMModel(
      id: id ?? this.id,
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
      spaceValue: spaceValue ?? this.spaceValue,
      steps: steps ?? this.steps,
      value: value ?? this.value,
    );
  }

  RPMModel.fromMap(DataMap map)
      : super(
          id: map['id'] as int,
          minValue: map['minValue'] as double,
          maxValue: map['maxValue'] as double,
          spaceValue: map['spaceValue'] as double,
          steps: map['steps'] as int,
          value: map['value'] as double,
        );

  DataMap toMap() {
    return {
      'id': id,
      'minValue': minValue,
      'maxValue': maxValue,
      'spaceValue': spaceValue,
      'steps': steps,
      'value': value,
    };
  }
}
