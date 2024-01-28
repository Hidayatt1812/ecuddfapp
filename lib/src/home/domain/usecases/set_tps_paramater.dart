import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/tps.dart';
import '../repository/home_repository.dart';

class SetTPSParameter implements UsecaseWithParams<TPS, SetTPSParameterParams> {
  const SetTPSParameter(this._repository);

  final HomeRepository _repository;

  @override
  ResultFuture<TPS> call(SetTPSParameterParams params) =>
      _repository.setTPSParameter(
        minValue: params.minValue,
        maxValue: params.maxValue,
        steps: params.steps,
      );
}

class SetTPSParameterParams extends Equatable {
  const SetTPSParameterParams({
    required this.minValue,
    required this.maxValue,
    required this.steps,
  });

  const SetTPSParameterParams.empty()
      : minValue = 0,
        maxValue = 0,
        steps = 0;

  final double minValue;
  final double maxValue;
  final int steps;

  @override
  List<Object?> get props => [minValue, maxValue, steps];
}
