import '../../../../core/utils/typedef.dart';
import '../../domain/entities/rpm.dart';

class RPMModel extends RPM {
  const RPMModel({
    required super.id,
    required super.isFirst,
    required super.isLast,
    required super.value,
    super.prevValue,
    super.nextValue,
  });

  const RPMModel.empty()
      : this(
          id: 0,
          isFirst: true,
          isLast: true,
          value: 0,
          prevValue: null,
          nextValue: null,
        );

  RPMModel copyWith({
    int? id,
    bool? isFirst,
    bool? isLast,
    double? value,
    double? prevValue,
    double? nextValue,
  }) {
    return RPMModel(
      id: id ?? this.id,
      isFirst: isFirst ?? this.isFirst,
      isLast: isLast ?? this.isLast,
      value: value ?? this.value,
      prevValue: prevValue ?? this.prevValue,
      nextValue: nextValue ?? this.nextValue,
    );
  }

  RPMModel.fromMap(DataMap map)
      : super(
          id: map['id'],
          isFirst: map['isFirst'],
          isLast: map['isLast'],
          value: map['value'],
          prevValue: map['prevValue'],
          nextValue: map['nextValue'],
        );

  DataMap toMap() {
    return {
      'id': id,
      'isFirst': isFirst,
      'isLast': isLast,
      'value': value,
      'prevValue': prevValue,
      'nextValue': nextValue,
    };
  }
}
