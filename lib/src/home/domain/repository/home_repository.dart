import '../../../../core/utils/typedef.dart';
import '../entities/rpm.dart';
import '../entities/timing.dart';
import '../entities/tps.dart';

abstract class HomeRepository {
  const HomeRepository();

  ResultStream<List<double>> getPortsValue({
    required String port,
  });

  ResultFuture<List<String>> getPorts();

  ResultFuture<Timing> getTimingCell({
    required TPS tps,
    required RPM rpm,
    required List<Timing> timings,
  });

  ResultFuture<List<Timing>> getTimingFromControlUnit();

  ResultFuture<List<TPS>> loadTPSValue();

  ResultFuture<List<RPM>> loadRPMValue();

  ResultFuture<List<Timing>> loadTimingValue();

  ResultFuture<void> postAllTiming({
    required List<Timing> timings,
  });

  ResultFuture<void> postDynamicTiming({
    required double value,
  });

  ResultFuture<void> saveValue({
    required List<TPS> tpss,
    required List<RPM> rpms,
    required List<Timing> timings,
  });

  ResultFuture<RPM> setRPMManually({
    required int position,
    required double value,
  });

  ResultFuture<List<RPM>> setRPMParameter({
    required double minValue,
    required double maxValue,
    required int steps,
  });

  ResultFuture<List<Timing>> setTimingManually({
    required List<int> ids,
    required List<Timing> timings,
    required double value,
  });

  ResultFuture<TPS> setTPSManually({
    required int position,
    required double value,
  });

  ResultFuture<List<TPS>> setTPSParameter({
    required double minValue,
    required double maxValue,
    required int steps,
  });
}
