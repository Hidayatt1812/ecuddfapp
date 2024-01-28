import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/tps.dart';
import '../repository/home_repository.dart';

class SetTPSManually implements UsecaseWithParams<TPS, SetTPSManuallyParams> {
  const SetTPSManually(this._repository);

  final HomeRepository _repository;

  @override
  ResultFuture<TPS> call(SetTPSManuallyParams params) =>
      _repository.setTPSManually(
        position: params.position,
        value: params.value,
      );
}

class SetTPSManuallyParams extends Equatable {
  const SetTPSManuallyParams({
    required this.position,
    required this.value,
  });

  const SetTPSManuallyParams.empty()
      : position = 0,
        value = 0;

  final int position;
  final double value;

  @override
  List<Object?> get props => [position, value];
}
