import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:ddfapp/core/errors/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../domain/entities/timing.dart';
import '../../domain/usecases/get_ports_value.dart';
import '../../domain/usecases/get_ports.dart';
import '../../domain/usecases/get_timing_cell.dart';
import '../../domain/usecases/get_timing_from_control_unit.dart';
import '../../domain/usecases/load_rpm_value.dart';
import '../../domain/usecases/load_timing_value.dart';
import '../../domain/usecases/load_tps_value.dart';
import '../../domain/usecases/post_all_timing.dart';
import '../../domain/usecases/post_dynamic_timing.dart';
import '../../domain/usecases/save_value.dart';
import '../../domain/usecases/set_rpm_manually.dart';
import '../../domain/usecases/set_rpm_parameter.dart';
import '../../domain/usecases/set_timing_manually.dart';
import '../../domain/usecases/set_tps_manually.dart';
import '../../domain/usecases/set_tps_paramater.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required GetPortsValue getPortsValue,
    required GetPorts getPorts,
    required GetTimingCell getTimingCell,
    required GetTimingFromControlUnit getTimingFromControlUnit,
    required LoadTPSValue loadTPSValue,
    required LoadRPMValue loadRPMValue,
    required LoadTimingValue loadTimingValue,
    required PostAllTiming postAllTiming,
    required PostDynamicTiming postDynamicTiming,
    required SaveValue saveValue,
    required SetRPMManually setRPMManually,
    required SetRPMParameter setRPMParameter,
    required SetTimingManually setTimingManually,
    required SetTPSManually setTPSManually,
    required SetTPSParameter setTPSParameter,
  })  : _getPortsValue = getPortsValue,
        _getPorts = getPorts,
        _getTimingCell = getTimingCell,
        _getTimingFromControlUnit = getTimingFromControlUnit,
        _loadTPSValue = loadTPSValue,
        _loadRPMValue = loadRPMValue,
        _loadTimingValue = loadTimingValue,
        _postAllTiming = postAllTiming,
        _postDynamicTiming = postDynamicTiming,
        _saveValue = saveValue,
        _setRPMManually = setRPMManually,
        _setRPMParameter = setRPMParameter,
        _setTimingManually = setTimingManually,
        _setTPSManually = setTPSManually,
        _setTPSParameter = setTPSParameter,
        super(const HomeInitial()) {
    on<HomeEvent>((event, emit) {
      emit(const HomeLoading());
    });
    // on<GetPortsValueEvent>(_getPortsValueHandler);
    on<GetPortsEvent>(_getPortsHandler);
    on<GetTimingCellEvent>(_getTimingCellHandler);
    on<GetTimingFromControlUnitEvent>(_getTimingFromControlUnitHandler);
    on<LoadTPSValueEvent>(_loadTPSValueHandler);
    on<LoadRPMValueEvent>(_loadRPMValueHandler);
    on<LoadTimingValueEvent>(_loadTimingValueHandler);
    on<PostAllTimingEvent>(_postAllTimingHandler);
    on<PostDynamicTimingEvent>(_postDynamicTimingHandler);
    on<SaveValueEvent>(_saveValueHandler);
    on<SetRPMManuallyEvent>(_setRPMManuallyHandler);
    on<SetRPMParameterEvent>(_setRPMParameterHandler);
    on<SetTimingManuallyEvent>(_setTimingManuallyHandler);
    on<SetTPSManuallyEvent>(_setTPSManuallyHandler);
    on<SetTPSParameterEvent>(_setTPSParameterHandler);
    on<SwitchPowerEvent>(_switchPowerHandler);
    on<StreamGetTPSRPMLinesValueEvent>(_getTPSRPMLinesValueHandler,
        transformer: (events, mapper) => events.switchMap(mapper));
    on<StopStreamDataEvent>(_stopStreamDataHandler);
  }

  // ignore: unused_field
  final GetPortsValue _getPortsValue;
  final GetPorts _getPorts;
  final GetTimingCell _getTimingCell;
  final GetTimingFromControlUnit _getTimingFromControlUnit;
  final LoadTPSValue _loadTPSValue;
  final LoadRPMValue _loadRPMValue;
  final LoadTimingValue _loadTimingValue;
  final PostAllTiming _postAllTiming;
  final PostDynamicTiming _postDynamicTiming;
  final SaveValue _saveValue;
  final SetRPMManually _setRPMManually;
  final SetRPMParameter _setRPMParameter;
  final SetTimingManually _setTimingManually;
  final SetTPSManually _setTPSManually;
  final SetTPSParameter _setTPSParameter;
  final StreamController<Either<Failure, List<double>>> _controllerRepo =
      StreamController();
  final StreamController<dynamic> _controllerDataSource = StreamController();

  // Future<void> _getPortsValueHandler(
  //   GetDynamicRPMEvent event,
  //   Emitter<HomeState> emit,
  // ) async {
  //   final result = await _getPortsValue(event.port);
  //   result.fold(
  //     (failure) => emit(HomeError(failure.message)),
  //     (data) => emit(HomeUpdated(data)),
  //   );
  // }

  Future<void> _getPortsHandler(
    GetPortsEvent event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _getPorts();
    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (data) => emit(PortLoaded(data)),
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

  Future<void> _loadTPSValueHandler(
    LoadTPSValueEvent event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _loadTPSValue();
    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (data) => emit(TpsLoaded(data)),
    );
  }

  Future<void> _loadRPMValueHandler(
    LoadRPMValueEvent event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _loadRPMValue();
    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (data) => emit(RpmLoaded(data)),
    );
  }

  Future<void> _loadTimingValueHandler(
    LoadTimingValueEvent event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _loadTimingValue();
    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (data) => emit(TimingLoaded(data)),
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
      tpss: event.tpss,
      rpms: event.rpms,
      timings: event.timings,
    ));

    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (_) => emit(const DataSaved()),
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
    print('timings.type: ${event.timings.runtimeType}');
    print('value.type: ${event.value.runtimeType}');
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
    emit(const HomePowerSwitched());
  }

  Future<void> _getTPSRPMLinesValueHandler(
    StreamGetTPSRPMLinesValueEvent event,
    Emitter<HomeState> emit,
  ) async {
    await emit.forEach(
      _getPortsValue(GetPortsValueParams(
        port: event.port,
        controllerRepo: _controllerRepo,
        controllerDataSource: _controllerDataSource,
      )),
      onData: (value) {
        value.fold(
          (failure) => emit(HomeError(failure.message)),
          (data) => emit(AxisUpdated(
            Size(
              data[0] * Random().nextInt(10),
              data[1] * Random().nextInt(10),
            ),
          )),
        );
        return const HomeIdle();
      },
      onError: (e, s) {
        debugPrintStack(stackTrace: s);
        return HomeError(e.toString());
      },
    );
  }

  Future<void> _stopStreamDataHandler(
    StopStreamDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    _controllerDataSource.close();
    _controllerRepo.close();
    emit(const StreamingDataStopped());
  }
}
