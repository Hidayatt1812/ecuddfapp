import 'package:fluent_ui/fluent_ui.dart';
import 'package:localstore/localstore.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    required SharedPreferences sharedPreferences,
  })  : _localstore = localstore,
        _sharedPreferences = sharedPreferences;

  final Localstore _localstore;
  final SharedPreferences _sharedPreferences;

  final String db = 'cartesius';

  @override
  Future<List<RPMModel>> loadRPMValue() async {
    try {
      final id = _sharedPreferences.getString(db);
      if (id == null) {
        throw const CacheException(message: 'No RPM value was found');
      }
      final data = await _localstore.collection('cartesius').doc(id).get();
      print(data);
      if (data == null || data.isEmpty) {
        throw const CacheException(message: 'No RPM value was found');
      }
      List<dynamic> result = data['rpms'];
      // data.forEach((key, value) {
      //   result = value['rpms'];
      // });
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
      final id = _sharedPreferences.getString(db);
      if (id == null) {
        throw const CacheException(message: 'No TPS value was found');
      }
      final data = await _localstore.collection('cartesius').doc(id).get();
      if (data == null || data.isEmpty) {
        throw const CacheException(message: 'No TPS value was found');
      }
      List<dynamic> result = data['tpss'];
      // data.forEach((key, value) {
      //   result = value['tpss'];
      // });
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
      final id = _sharedPreferences.getString(db);
      if (id == null) {
        throw const CacheException(message: 'No Timing value was found');
      }
      final data = await _localstore.collection('cartesius').doc(id).get();
      if (data == null || data.isEmpty) {
        throw const CacheException(message: 'No Timing value was found');
      }
      List<dynamic> result = data['timings'];
      // data.forEach((key, value) {
      //   result = value['timings'];
      // });
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
      final id = _localstore.collection(db).doc().id;
      await _sharedPreferences.setString(db, id);

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
