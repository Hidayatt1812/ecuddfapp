import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/rpm.dart';
import '../repository/home_repository.dart';

class SetRPMParameter
    implements UsecaseWithParams<List<RPM>, SetRPMParameterParams> {
  const SetRPMParameter(this._repository);

  final HomeRepository _repository;

  @override
  ResultFuture<List<RPM>> call(SetRPMParameterParams params) =>
      _repository.setRPMParameter(
        minValue: params.minValue,
        maxValue: params.maxValue,
        steps: params.steps,
      );
}

class SetRPMParameterParams extends Equatable {
  const SetRPMParameterParams({
    required this.minValue,
    required this.maxValue,
    required this.steps,
  });

  const SetRPMParameterParams.empty()
      : minValue = 0,
        maxValue = 0,
        steps = 0;

  final double minValue;
  final double maxValue;
  final int steps;

  @override
  List<Object?> get props => [minValue, maxValue, steps];
}
