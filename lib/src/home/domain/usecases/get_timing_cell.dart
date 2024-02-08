import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/rpm.dart';
import '../entities/timing.dart';
import '../entities/tps.dart';
import '../repository/home_repository.dart';

class GetTimingCell implements UsecaseWithParams<Timing, GetTimingCellParams> {
  const GetTimingCell(this._repository);

  final HomeRepository _repository;

  @override
  ResultFuture<Timing> call(GetTimingCellParams params) =>
      _repository.getTimingCell(
        tps: params.tps,
        rpm: params.rpm,
        timings: params.timings,
      );
}

class GetTimingCellParams extends Equatable {
  const GetTimingCellParams({
    required this.tps,
    required this.rpm,
    required this.timings,
  });

  const GetTimingCellParams.empty()
      : tps = const TPS.empty(),
        rpm = const RPM.empty(),
        timings = const <Timing>[];

  final TPS tps;
  final RPM rpm;
  final List<Timing> timings;

  @override
  List<Object?> get props => [tps, rpm, timings];
}
