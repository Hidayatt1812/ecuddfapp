import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:localstore/localstore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/core_utils.dart';
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

      String tpssList =
          tpss.map((e) => CoreUtils.doubleToHex(e.value)).join(',');
      for (int i = tpss.length; i < 30; i++) {
        tpssList += ',FFFF';
      }
      print('tpssList: $tpssList');
      String rpmsList =
          rpms.map((e) => CoreUtils.doubleToHex(e.value)).join(',');
      for (int i = rpms.length; i < 30; i++) {
        rpmsList += ',FFFF';
      }
      print('rpmsList: $rpmsList');
      String timingsList = "";

      // fill the rest of the list with FFFF, considering the 30 of i and j
      for (int i = 0; i < 30; i++) {
        for (int j = 0; j < 30; j++) {
          print(i * 30 + j);
          if (j < tpss.length && i * tpss.length + j < timings.length) {
            timingsList +=
                CoreUtils.doubleToHex(timings[i * tpss.length + j].value);
          } else {
            timingsList += 'FFFF';
          }
          if (j < 29) {
            timingsList += ',';
          }
        }
        // print('timingsList: $timingsList}');
        if (i < 29) {
          timingsList += ',';
        }
      }
      print('timingsList: $timingsList, length: ${timingsList.length}');

      // |null|tps[0]|tps[1]|...|tps[29]|
      // |rpms[29]|timings[29*29 + 0]|timings[29*29 + 1]|...|timings[29*29 + 29]|
      // |rpms[28]|timings[28*29 + 0]|timings[28*29 + 1]|...|timings[28*29 + 29]|
      // |...|...|...|...|...|
      // |rpms[0]|timings[0*29 + 0]|timings[0*29 + 1]|...|timings[0*29 + 29]|

      // convert to csv
      List<String> csv = [];
      csv.add(',${tpssList}');
      for (int i = 29; i >= 0; i--) {
        List<String> timingsSubList = [];
        for (int j = 0; j < 30; j++) {
          timingsSubList.add(timingsList.split(",")[i * 30 + j]);
        }
        csv.add('${rpmsList.split(",")[i]},${timingsSubList.join(",")}');
      }

      print('csv: $csv');

      String? savePath = await FilePicker.platform.saveFile(
        fileName: 'cartesius.csv',
        allowedExtensions: ['svg'],
        type: FileType.custom,
        lockParentWindow: true,
      );

      if (savePath == null) {
        throw const CacheException(message: 'No path was found');
      }

      File file = File(savePath);

      // Write to the file
      await file.writeAsString(csv.join('\n'));

      print("CSV file saved to: $savePath");

      print('savePath: $savePath');
    } on CacheException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw CacheException(message: e.toString());
    }
  }
}
