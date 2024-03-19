part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetPortsEvent extends HomeEvent {
  const GetPortsEvent();
}

class GetTimingCellEvent extends HomeEvent {
  const GetTimingCellEvent({
    required this.tps,
    required this.rpm,
    required this.timings,
  });

  final dynamic tps;
  final dynamic rpm;
  final dynamic timings;

  @override
  List<Object> get props => [tps, rpm, timings];
}

class GetTimingFromControlUnitEvent extends HomeEvent {
  const GetTimingFromControlUnitEvent();
}

class LoadTPSValueEvent extends HomeEvent {
  const LoadTPSValueEvent();
}

class LoadRPMValueEvent extends HomeEvent {
  const LoadRPMValueEvent();
}

class LoadTimingValueEvent extends HomeEvent {
  const LoadTimingValueEvent();
}

class PostAllTimingEvent extends HomeEvent {
  const PostAllTimingEvent({
    required this.timings,
  });

  final dynamic timings;

  @override
  List<Object> get props => [timings];
}

class PostDynamicTimingEvent extends HomeEvent {
  const PostDynamicTimingEvent({
    required this.value,
  });

  final double value;

  @override
  List<Object> get props => [value];
}

class SaveValueEvent extends HomeEvent {
  const SaveValueEvent({
    required this.tpss,
    required this.rpms,
    required this.timings,
  });

  final dynamic tpss;
  final dynamic rpms;
  final dynamic timings;

  @override
  List<Object> get props => [tpss, rpms, timings];
}

class SetRPMManuallyEvent extends HomeEvent {
  const SetRPMManuallyEvent({
    required this.position,
    required this.value,
  });

  final int position;
  final double value;

  @override
  List<Object> get props => [position, value];
}

class SetRPMParameterEvent extends HomeEvent {
  const SetRPMParameterEvent({
    required this.minValue,
    required this.maxValue,
    required this.steps,
  });

  final double minValue;
  final double maxValue;
  final int steps;

  @override
  List<Object> get props => [minValue, maxValue, steps];
}

class SetTimingManuallyEvent extends HomeEvent {
  const SetTimingManuallyEvent({
    required this.ids,
    required this.timings,
    required this.value,
  });

  final List<int> ids;
  final dynamic timings;
  final double value;

  @override
  List<Object> get props => [ids, timings, value];
}

class SetTPSManuallyEvent extends HomeEvent {
  const SetTPSManuallyEvent({
    required this.position,
    required this.value,
  });

  final int position;
  final double value;

  @override
  List<Object> get props => [position, value];
}

class SetTPSParameterEvent extends HomeEvent {
  const SetTPSParameterEvent({
    required this.minValue,
    required this.maxValue,
    required this.steps,
  });

  final double minValue;
  final double maxValue;
  final int steps;

  @override
  List<Object> get props => [minValue, maxValue, steps];
}

class SwitchPowerEvent extends HomeEvent {
  const SwitchPowerEvent({
    required this.serialPort,
    required this.tpss,
    required this.rpms,
    required this.timings,
    required this.status,
  });
  final SerialPort serialPort;
  final dynamic tpss;
  final dynamic rpms;
  final dynamic timings;
  final bool status;

  @override
  List<Object> get props => [serialPort, tpss, rpms, timings, status];
}

class StopStreamDataEvent extends HomeEvent {
  const StopStreamDataEvent({
    required this.serialPortReader,
  });
  final SerialPortReader serialPortReader;
}

class GetTPSRPMLinesValueEvent extends HomeEvent {
  final SerialPortReader serialPortReader;
  const GetTPSRPMLinesValueEvent({
    required this.serialPortReader,
  });
}

class SendDataToECUEvent extends HomeEvent {
  const SendDataToECUEvent({
    required this.serialPort,
    required this.tpss,
    required this.rpms,
    required this.timings,
    required this.status,
  });
  final SerialPort serialPort;
  final dynamic tpss;
  final dynamic rpms;
  final dynamic timings;
  final bool status;

  @override
  List<Object> get props => [serialPort, tpss, rpms, timings, status];
}

class GetDataFromECUEvent extends HomeEvent {
  const GetDataFromECUEvent({
    required this.serialPort,
  });

  final SerialPort serialPort;

  @override
  List<Object> get props => [serialPort];
}
