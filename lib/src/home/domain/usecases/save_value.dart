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
        tpss: params.tpss,
        rpms: params.rpms,
        timings: params.timings,
      );
}

class SaveValueParams extends Equatable {
  const SaveValueParams({
    required this.tpss,
    required this.rpms,
    required this.timings,
  });

  const SaveValueParams.empty()
      : tpss = const <TPS>[],
        rpms = const <RPM>[],
        timings = const <Timing>[];

  final List<TPS> tpss;
  final List<RPM> rpms;
  final List<Timing> timings;

  @override
  List<Object?> get props => [tpss, rpms, timings];
}
