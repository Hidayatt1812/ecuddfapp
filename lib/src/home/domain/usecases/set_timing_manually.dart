import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/timing.dart';
import '../repository/home_repository.dart';

class SetTimingManually
    implements UsecaseWithParams<List<Timing>, SetTimingManuallyParams> {
  const SetTimingManually(this._repository);

  final HomeRepository _repository;

  @override
  ResultFuture<List<Timing>> call(SetTimingManuallyParams params) =>
      _repository.setTimingManually(
        ids: params.ids,
        timings: params.timings,
        value: params.value,
      );
}

class SetTimingManuallyParams extends Equatable {
  const SetTimingManuallyParams({
    required this.ids,
    required this.timings,
    required this.value,
  });

  const SetTimingManuallyParams.empty()
      : ids = const <int>[],
        timings = const <Timing>[],
        value = 0;

  final List<int> ids;
  final List<Timing> timings;
  final double value;

  @override
  List<Object?> get props => [ids, timings, value];
}
