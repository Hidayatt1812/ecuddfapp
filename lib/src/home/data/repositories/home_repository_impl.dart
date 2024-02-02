import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/typedef.dart';
import '../../domain/entities/rpm.dart';
import '../../domain/entities/timing.dart';
import '../../domain/entities/tps.dart';
import '../../domain/repository/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._remoteDataSource);

  // ignore: unused_field
  final HomeRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<RPM> getDynamicRPM() async {
    try {
      return const Right(RPM.empty());
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<TPS> getDynamicTPS() async {
    try {
      return const Right(TPS.empty());
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
    required TPS tps,
    required RPM rpm,
    required List<Timing> timings,
  }) async {
    try {
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
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
      return const Right(<Timing>[]);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<bool> switchPower({
    required bool status,
  }) async {
    try {
      return const Right(false);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
