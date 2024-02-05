part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetDynamicRPMEvent extends HomeEvent {
  const GetDynamicRPMEvent();
}

class GetDynamicTPSEvent extends HomeEvent {
  const GetDynamicTPSEvent();
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
    required this.status,
  });

  final bool status;

  @override
  List<Object> get props => [status];
}

class StreamGetTPSRPMLinesValueEvent extends HomeEvent {
  final StreamController<double> tpsLinesController;
  final StreamController<double> rpmLinesController;

  const StreamGetTPSRPMLinesValueEvent({
    required this.tpsLinesController,
    required this.rpmLinesController,
  });
}
