import 'package:equatable/equatable.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../repository/home_repository.dart';

class SwitchPower implements UsecaseWithParams<void, SwitchPowerParams> {
  const SwitchPower(this._repository);

  final HomeRepository _repository;

  @override
  ResultFuture<void> call(SwitchPowerParams params) => _repository.switchPower(
        serialPort: params.serialPort,
        status: params.status,
      );
}

class SwitchPowerParams extends Equatable {
  const SwitchPowerParams({
    required this.serialPort,
    required this.status,
  });

  final SerialPort serialPort;
  final bool status;

  @override
  List<Object?> get props => [serialPort, status];
}
