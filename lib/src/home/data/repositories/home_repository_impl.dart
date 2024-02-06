import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/typedef.dart';
import '../../domain/entities/rpm.dart';
import '../../domain/entities/timing.dart';
import '../../domain/entities/tps.dart';
import '../../domain/repository/home_repository.dart';
import '../datasources/home_local_data_source.dart';
import '../datasources/home_port_data_source.dart';
import '../datasources/home_remote_data_source.dart';
import '../models/rpm_model.dart';
import '../models/timing_model.dart';
import '../models/tps_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._portDataSource,
  );

  // ignore: unused_field
  final HomeRemoteDataSource _remoteDataSource;

  final HomeLocalDataSource _localDataSource;

  final HomePortDataSource _portDataSource;

  @override
  ResultStream<List<double>> getPortsValue({
    required String port,
  }) async* {
    try {
      List<double> result = [];
      _portDataSource.getPortsValue(port: port).listen((event) async {
        result = event;
      });
      yield Right(result);
    } on ServerException catch (e) {
      yield Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<String>> getPorts() async {
    try {
      final result = await _portDataSource.getPorts();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<Timing> getTimingCell({
    required TPS tps,
    required RPM rpm,
    required List<Timing> timings,
  }) async {
    try {
      return const Right(Timing.empty());
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Timing>> getTimingFromControlUnit() async {
    try {
      return const Right(<Timing>[]);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> postAllTiming({
    required List<Timing> timings,
  }) async {
    try {
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> postDynamicTiming({required double value}) async {
    try {
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> saveValue({
    required List<TPS> tpss,
    required List<RPM> rpms,
    required List<Timing> timings,
  }) async {
    try {
      final result = await _localDataSource.saveValue(
        tpss: tpss
            .map(
              (e) => TPSModel(
                id: e.id,
                isFirst: e.isFirst,
                isLast: e.isLast,
                value: e.value,
                prevValue: e.prevValue,
                nextValue: e.nextValue,
              ),
            )
            .toList(),
        rpms: rpms
            .map(
              (e) => RPMModel(
                id: e.id,
                isFirst: e.isFirst,
                isLast: e.isLast,
                value: e.value,
                prevValue: e.prevValue,
                nextValue: e.nextValue,
              ),
            )
            .toList(),
        timings: timings
            .map(
              (e) => TimingModel(
                id: e.id,
                tpsValue: e.tpsValue,
                mintpsValue: e.mintpsValue,
                maxtpsValue: e.maxtpsValue,
                rpmValue: e.rpmValue,
                minrpmValue: e.minrpmValue,
                maxrpmValue: e.maxrpmValue,
                value: e.value,
              ),
            )
            .toList(),
      );
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure.fromException(e));
    }
  }

  @override
  ResultFuture<RPM> setRPMManually({
    required int position,
    required double value,
  }) async {
    try {
      return const Right(RPM.empty());
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<RPM>> setRPMParameter({
    required double minValue,
    required double maxValue,
    required int steps,
  }) async {
    try {
      double interval = (maxValue - minValue) / (steps - 1);
      return Right(
        List<RPM>.generate(
          steps,
          (index) => RPM(
            id: index,
            isFirst: index == 0,
            isLast: index == steps - 1,
            value: index * interval,
            prevValue: index == 0 ? null : (index - 1) * interval,
            nextValue: index == steps - 1 ? null : (index + 1) * interval,
          ),
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<TPS> setTPSManually({
    required int position,
    required double value,
  }) async {
    try {
      return const Right(TPS.empty());
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<TPS>> setTPSParameter({
    required double minValue,
    required double maxValue,
    required int steps,
  }) async {
    try {
      double interval = (maxValue - minValue) / (steps - 1);
      return Right(
        List<TPS>.generate(
          steps,
          (index) => TPS(
            id: index,
            isFirst: index == 0,
            isLast: index == steps - 1,
            value: index * interval,
            prevValue: index == 0 ? null : (index - 1) * interval,
            nextValue: index == steps - 1 ? null : (index + 1) * interval,
          ),
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Timing>> setTimingManually({
    required List<int> ids,
    required List<Timing> timings,
    required double value,
  }) async {
    try {
      for (int i = 0; i < timings.length; i++) {
        if (ids.contains(timings[i].id)) {
          timings[i] = TimingModel(
            id: timings[i].id,
            tpsValue: timings[i].tpsValue,
            mintpsValue: timings[i].mintpsValue,
            maxtpsValue: timings[i].maxtpsValue,
            rpmValue: timings[i].rpmValue,
            minrpmValue: timings[i].minrpmValue,
            maxrpmValue: timings[i].maxrpmValue,
            value: value,
          );
        }
      }

      return Right(timings);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<RPM>> loadRPMValue() async {
    try {
      dynamic result = await _localDataSource.loadRPMValue();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<TPS>> loadTPSValue() async {
    try {
      dynamic result = await _localDataSource.loadTPSValue();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Timing>> loadTimingValue() async {
    try {
      dynamic result = await _localDataSource.loadTimingValue();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure.fromException(e));
    }
  }
}
