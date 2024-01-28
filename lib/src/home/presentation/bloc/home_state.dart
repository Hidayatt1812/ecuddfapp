part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {
  const HomeInitial();
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

class HomePowerOff extends HomeState {
  const HomePowerOff();
}

class HomePowerOn extends HomeState {
  const HomePowerOn();
}
