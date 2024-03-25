import 'package:equatable/equatable.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/rpm.dart';
import '../entities/timing.dart';
import '../entities/tps.dart';
import '../repository/home_repository.dart';

class SwitchPower implements UsecaseWithParams<void, SwitchPowerParams> {
  const SwitchPower(this._repository);

  final HomeRepository _repository;

  @override
  ResultFuture<void> call(SwitchPowerParams params) => _repository.switchPower(
        serialPort: params.serialPort,
        tpss: params.tpss,
        rpms: params.rpms,
        timings: params.timings,
        status: params.status,
      );
}

class SwitchPowerParams extends Equatable {
  const SwitchPowerParams({
    required this.serialPort,
    required this.tpss,
    required this.rpms,
    required this.timings,
    required this.status,
  });

  final SerialPort serialPort;
  final List<TPS> tpss;
  final List<RPM> rpms;
  final List<Timing> timings;
  final bool status;

  @override
  List<Object?> get props => [serialPort, tpss, rpms, timings, status];
}
