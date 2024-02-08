import '../../../../core/utils/typedef.dart';
import '../../domain/entities/timing.dart';

class TimingModel extends Timing {
  // final int id;
  // final double tpsValue;
  // final double mintpsValue;
  // final double maxtpsValue;
  // final double rpmValue;
  // final double minrpmValue;
  // final double maxrpmValue;
  // final double value;
  const TimingModel({
    required super.id,
    required super.tpsValue,
    required super.mintpsValue,
    required super.maxtpsValue,
    required super.rpmValue,
    required super.minrpmValue,
    required super.maxrpmValue,
    required super.value,
  });

  const TimingModel.empty()
      : this(
          id: 0,
          tpsValue: 0,
          mintpsValue: 0,
          maxtpsValue: 0.5,
          rpmValue: 0,
          minrpmValue: 0,
          maxrpmValue: 0.5,
          value: 0,
        );

  TimingModel copyWith({
    int? id,
    double? tpsValue,
    double? mintpsValue,
    double? maxtpsValue,
    double? rpmValue,
    double? minrpmValue,
    double? maxrpmValue,
    double? value,
  }) {
    return TimingModel(
      id: id ?? this.id,
      tpsValue: tpsValue ?? this.tpsValue,
      mintpsValue: mintpsValue ?? this.mintpsValue,
      maxtpsValue: maxtpsValue ?? this.maxtpsValue,
      rpmValue: rpmValue ?? this.rpmValue,
      minrpmValue: minrpmValue ?? this.minrpmValue,
      maxrpmValue: maxrpmValue ?? this.maxrpmValue,
      value: value ?? this.value,
    );
  }

  TimingModel.fromMap(DataMap map)
      : super(
          id: map['id'] as int,
          tpsValue: map['tpsValue'] as double,
          mintpsValue: map['mintpsValue'] as double,
          maxtpsValue: map['maxtpsValue'] as double,
          rpmValue: map['rpmValue'] as double,
          minrpmValue: map['minrpmValue'] as double,
          maxrpmValue: map['maxrpmValue'] as double,
          value: map['value'] as double,
        );

  DataMap toMap() {
    return {
      'id': id,
      'tpsValue': tpsValue,
      'mintpsValue': mintpsValue,
      'maxtpsValue': maxtpsValue,
      'rpmValue': rpmValue,
      'minrpmValue': minrpmValue,
      'maxrpmValue': maxrpmValue,
      'value': value,
    };
  }
}
