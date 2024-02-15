part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeIdle extends HomeState {
  const HomeIdle();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeError extends HomeState {
  const HomeError(
    this.message,
  );

  final String message;

  @override
  List<Object> get props => [message];
}

class HomeUpdating extends HomeState {
  const HomeUpdating();
}

class HomeUpdated extends HomeState {
  const HomeUpdated(this.data);

  final dynamic data;

  @override
  List<Object> get props => [data];
}

class AxisUpdated extends HomeState {
  const AxisUpdated(this.data);

  final dynamic data;

  @override
  List<Object> get props => [data];
}

class DataSaved extends HomeState {
  const DataSaved();
}

class TpsLoaded extends HomeState {
  const TpsLoaded(this.data);

  final dynamic data;

  @override
  List<Object> get props => [data];
}

class RpmLoaded extends HomeState {
  const RpmLoaded(this.data);

  final dynamic data;

  @override
  List<Object> get props => [data];
}

class TimingLoaded extends HomeState {
  const TimingLoaded(this.data);

  final List<Timing> data;

  @override
  List<Object> get props => [data];
}

class PortLoaded extends HomeState {
  const PortLoaded(this.data);

  final List<String> data;

  @override
  List<Object> get props => [data];
}

class HomePowerSwitched extends HomeState {
  const HomePowerSwitched(this.status);

  final bool status;

  @override
  List<Object> get props => [status];
}

class StreamingDataStopped extends HomeState {
  const StreamingDataStopped();
}

class DataSent extends HomeState {
  const DataSent();
}
