import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/rpm.dart';
import '../entities/timing.dart';
import '../entities/tps.dart';
import '../repository/home_repository.dart';

class SaveValue implements UsecaseWithParams<void, SaveValueParams> {
  const SaveValue(this._repository);

  final HomeRepository _repository;

  @override
  ResultFuture<void> call(SaveValueParams params) => _repository.saveValue(
        tps: params.tps,
        rpm: params.rpm,
        timings: params.timings,
      );
}

class SaveValueParams extends Equatable {
  const SaveValueParams({
    required this.tps,
    required this.rpm,
    required this.timings,
  });

  const SaveValueParams.empty()
      : tps = const TPS.empty(),
        rpm = const RPM.empty(),
        timings = const <Timing>[];

  final TPS tps;
  final RPM rpm;
  final List<Timing> timings;

  @override
  List<Object?> get props => [tps, rpm, timings];
}
