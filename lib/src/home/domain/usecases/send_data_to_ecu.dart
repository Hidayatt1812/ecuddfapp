import 'package:equatable/equatable.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/rpm.dart';
import '../entities/timing.dart';
import '../entities/tps.dart';
import '../repository/home_repository.dart';

class SendDataToECU implements UsecaseWithParams<void, SendDataToECUParams> {
  const SendDataToECU(this._repository);

  final HomeRepository _repository;

  @override
  ResultFuture<void> call(SendDataToECUParams params) =>
      _repository.sendDataToECU(
        serialPort: params.serialPort,
        tpss: params.tpss,
        rpms: params.rpms,
        timings: params.timings,
      );
}

class SendDataToECUParams extends Equatable {
  const SendDataToECUParams({
    required this.serialPort,
    required this.tpss,
    required this.rpms,
    required this.timings,
  });

  final SerialPort serialPort;
  final List<TPS> tpss;
  final List<RPM> rpms;
  final List<Timing> timings;

  @override
  List<Object?> get props => [tpss, rpms, timings];
}
