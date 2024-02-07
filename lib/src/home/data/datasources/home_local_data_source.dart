import 'package:fluent_ui/fluent_ui.dart';
import 'package:localstore/localstore.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/rpm_model.dart';
import '../models/timing_model.dart';
import '../models/tps_model.dart';

abstract class HomeLocalDataSource {
  const HomeLocalDataSource();

  Future<void> saveValue({
    required List<TPSModel> tpss,
    required List<RPMModel> rpms,
    required List<TimingModel> timings,
  });

  Future<List<TPSModel>> loadTPSValue();

  Future<List<RPMModel>> loadRPMValue();

  Future<List<TimingModel>> loadTimingValue();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  const HomeLocalDataSourceImpl({
    required Localstore localstore,
  }) : _localstore = localstore;

  final Localstore _localstore;

  @override
  Future<List<RPMModel>> loadRPMValue() async {
    try {
      final data = await _localstore.collection('cartesius').get();
      if (data == null || data.isEmpty) {
        throw const CacheException(message: 'No RPM value was found');
      }
      List<dynamic> result = [];
      data.forEach((key, value) {
        result = value['rpms'];
      });
      final rpms = result.map((e) => RPMModel.fromMap(e)).toList();
      return rpms;
    } on CacheException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<List<TPSModel>> loadTPSValue() async {
    try {
      final data = await _localstore.collection('cartesius').get();
      if (data == null || data.isEmpty) {
        throw const CacheException(message: 'No TPS value was found');
      }
      List<dynamic> result = [];
      data.forEach((key, value) {
        result = value['tpss'];
      });
      List<TPSModel> tpss = result.map((e) => TPSModel.fromMap(e)).toList();
      return tpss;
    } on CacheException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<List<TimingModel>> loadTimingValue() async {
    try {
      final data = await _localstore.collection('cartesius').get();
      if (data == null || data.isEmpty) {
        throw const CacheException(message: 'No Timing value was found');
      }
      List<dynamic> result = [];
      data.forEach((key, value) {
        result = value['timings'];
      });
      final timings = result.map((e) => TimingModel.fromMap(e)).toList();
      return timings;
    } on CacheException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> saveValue({
    required List<TPSModel> tpss,
    required List<RPMModel> rpms,
    required List<TimingModel> timings,
  }) async {
    try {
      final id = _localstore.collection('cartesius').doc().id;
      print(id);

      _localstore.collection('cartesius').doc(id).delete();

// save the item
      _localstore.collection('cartesius').doc(id).set({
        'tpss': tpss.map((e) => e.toMap()).toList(),
        'rpms': rpms.map((e) => e.toMap()).toList(),
        'timings': timings.map((e) => e.toMap()).toList(),
      });
    } on CacheException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw CacheException(message: e.toString());
    }
  }
}
