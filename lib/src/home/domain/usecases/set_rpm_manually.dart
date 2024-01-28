import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/rpm.dart';
import '../repository/home_repository.dart';

class SetRPMManually implements UsecaseWithParams<RPM, SetRPMManuallyParams> {
  const SetRPMManually(this._repository);

  final HomeRepository _repository;

  @override
  ResultFuture<RPM> call(SetRPMManuallyParams params) =>
      _repository.setRPMManually(
        position: params.position,
        value: params.value,
      );
}

class SetRPMManuallyParams extends Equatable {
  const SetRPMManuallyParams({
    required this.position,
    required this.value,
  });

  const SetRPMManuallyParams.empty()
      : position = 0,
        value = 0;

  final int position;
  final double value;

  @override
  List<Object?> get props => [position, value];
}
