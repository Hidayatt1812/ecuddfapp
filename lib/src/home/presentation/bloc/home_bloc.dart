import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/usecases/get_dynamic_rpm.dart';
import '../../domain/usecases/get_dynamic_tps.dart';
import '../../domain/usecases/get_timing_cell.dart';
import '../../domain/usecases/get_timing_from_control_unit.dart';
import '../../domain/usecases/post_all_timing.dart';
import '../../domain/usecases/post_dynamic_timing.dart';
import '../../domain/usecases/save_value.dart';
import '../../domain/usecases/set_rpm_manually.dart';
import '../../domain/usecases/set_rpm_parameter.dart';
import '../../domain/usecases/set_timing_manually.dart';
import '../../domain/usecases/set_tps_manually.dart';
import '../../domain/usecases/set_tps_paramater.dart';
import '../../domain/usecases/switch_power.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required GetDynamicRPM getDynamicRPM,
    required GetDynamicTPS getDynamicTPS,
    required GetTimingCell getTimingCell,
    required GetTimingFromControlUnit getTimingFromControlUnit,
    required PostAllTiming postAllTiming,
    required PostDynamicTiming postDynamicTiming,
    required SaveValue saveValue,
    required SetRPMManually setRPMManually,
    required SetRPMParameter setRPMParameter,
    required SetTimingManually setTimingManually,
    required SetTPSManually setTPSManually,
    required SetTPSParameter setTPSParameter,
    required SwitchPower switchPower,
  })  : _getDynamicRPM = getDynamicRPM,
        _getDynamicTPS = getDynamicTPS,
        _getTimingCell = getTimingCell,
        _getTimingFromControlUnit = getTimingFromControlUnit,
        _postAllTiming = postAllTiming,
        _postDynamicTiming = postDynamicTiming,
        _saveValue = saveValue,
        _setRPMManually = setRPMManually,
        _setRPMParameter = setRPMParameter,
        _setTimingManually = setTimingManually,
        _setTPSManually = setTPSManually,
        _setTPSParameter = setTPSParameter,
        _switchPower = switchPower,
        super(const HomeInitial()) {
    on<HomeEvent>((event, emit) {
      emit(const HomeLoading());
    });
    on<GetDynamicRPMEvent>(_getDynamicRPMHandler);
    on<GetDynamicTPSEvent>(_getDynamicTPSHandler);
    on<GetTimingCellEvent>(_getTimingCellHandler);
    on<GetTimingFromControlUnitEvent>(_getTimingFromControlUnitHandler);
    on<PostAllTimingEvent>(_postAllTimingHandler);
    on<PostDynamicTimingEvent>(_postDynamicTimingHandler);
    on<SaveValueEvent>(_saveValueHandler);
    on<SetRPMManuallyEvent>(_setRPMManuallyHandler);
    on<SetRPMParameterEvent>(_setRPMParameterHandler);
    on<SetTimingManuallyEvent>(_setTimingManuallyHandler);
    on<SetTPSManuallyEvent>(_setTPSManuallyHandler);
    on<SetTPSParameterEvent>(_setTPSParameterHandler);
    on<SwitchPowerEvent>(_switchPowerHandler);
  }

  final GetDynamicRPM _getDynamicRPM;
  final GetDynamicTPS _getDynamicTPS;
  final GetTimingCell _getTimingCell;
  final GetTimingFromControlUnit _getTimingFromControlUnit;
  final PostAllTiming _postAllTiming;
  final PostDynamicTiming _postDynamicTiming;
  final SaveValue _saveValue;
  final SetRPMManually _setRPMManually;
  final SetRPMParameter _setRPMParameter;
  final SetTimingManually _setTimingManually;
  final SetTPSManually _setTPSManually;
  final SetTPSParameter _setTPSParameter;
  final SwitchPower _switchPower;

  Future<void> _getDynamicRPMHandler(
    GetDynamicRPMEvent event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _getDynamicRPM();
    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (data) => emit(HomeUpdated(data)),
    );
  }

  Future<void> _getDynamicTPSHandler(
    GetDynamicTPSEvent event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _getDynamicTPS();
    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (data) => emit(HomeUpdated(data)),
    );
  }

  Future<void> _getTimingCellHandler(
    GetTimingCellEvent event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _getTimingCell(GetTimingCellParams(
      tps: event.tps,
      rpm: event.rpm,
      timings: event.timings,
    ));
    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (data) => emit(HomeUpdated(data)),
    );
  }

  Future<void> _getTimingFromControlUnitHandler(
    GetTimingFromControlUnitEvent event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _getTimingFromControlUnit();
    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (data) => emit(HomeUpdated(data)),
    );
  }

  Future<void> _postAllTimingHandler(
    PostAllTimingEvent event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _postAllTiming(event.timings);

    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (_) => emit(const HomeUpdated(null)),
    );
  }

  Future<void> _postDynamicTimingHandler(
    PostDynamicTimingEvent event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _postDynamicTiming(event.value);

    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (_) => emit(const HomeUpdated(null)),
    );
  }

  Future<void> _saveValueHandler(
    SaveValueEvent event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _saveValue(SaveValueParams(
      tps: event.tps,
      rpm: event.rpm,
      timings: event.timings,
    ));

    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (_) => emit(const HomeUpdated(null)),
    );
  }

  Future<void> _setRPMManuallyHandler(
    SetRPMManuallyEvent event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _setRPMManually(SetRPMManuallyParams(
      position: event.position,
      value: event.value,
    ));

    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (data) => emit(HomeUpdated(data)),
    );
  }

  Future<void> _setRPMParameterHandler(
    SetRPMParameterEvent event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _setRPMParameter(SetRPMParameterParams(
      minValue: event.minValue,
      maxValue: event.maxValue,
      steps: event.steps,
    ));

    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (data) => emit(HomeUpdated(data)),
    );
  }

  Future<void> _setTimingManuallyHandler(
    SetTimingManuallyEvent event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _setTimingManually(SetTimingManuallyParams(
      ids: event.ids,
      timings: event.timings,
      value: event.value,
    ));

    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (data) => emit(HomeUpdated(data)),
    );
  }

  Future<void> _setTPSManuallyHandler(
    SetTPSManuallyEvent event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _setTPSManually(SetTPSManuallyParams(
      position: event.position,
      value: event.value,
    ));

    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (data) => emit(HomeUpdated(data)),
    );
  }

  Future<void> _setTPSParameterHandler(
    SetTPSParameterEvent event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _setTPSParameter(SetTPSParameterParams(
      minValue: event.minValue,
      maxValue: event.maxValue,
      steps: event.steps,
    ));

    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (data) => emit(HomeUpdated(data)),
    );
  }

  Future<void> _switchPowerHandler(
    SwitchPowerEvent event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _switchPower(event.status);

    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (_) => emit(const HomeUpdated(null)),
    );
  }
}
