import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
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

  Future<List<dynamic>> getDataFromCSV();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  const HomeLocalDataSourceImpl({
    required Localstore localstore,
    required SharedPreferences sharedPreferences,
    required FilePicker filePicker,
  })  : _localstore = localstore,
        _sharedPreferences = sharedPreferences,
        _filePicker = filePicker;

  final Localstore _localstore;
  final SharedPreferences _sharedPreferences;
  final FilePicker _filePicker;

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
      String rpmsList =
          rpms.map((e) => CoreUtils.doubleToHex(e.value)).join(',');
      for (int i = rpms.length; i < 30; i++) {
        rpmsList += ',FFFF';
      }
      String timingsList = "";

      for (int i = 0; i < 30; i++) {
        for (int j = 0; j < 30; j++) {
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
        if (i < 29) {
          timingsList += ',';
        }
      }

      List<String> csv = [];
      csv.add(',$tpssList');
      for (int i = 29; i >= 0; i--) {
        List<String> timingsSubList = [];
        for (int j = 0; j < 30; j++) {
          timingsSubList.add(timingsList.split(",")[i * 30 + j]);
        }
        csv.add('${rpmsList.split(",")[i]},${timingsSubList.join(",")}');
      }

      DateTime now = DateTime.now();

      String? savePath = await _filePicker.saveFile(
        fileName:
            'ddfecuapp_datatables_${DateFormat('yyyyMMddHHmmss').format(now)}.csv',
        allowedExtensions: ['csv'],
        type: FileType.custom,
        lockParentWindow: true,
      );

      if (savePath == null) {
        throw const CacheException(message: 'No path was found');
      }

      File file = File(savePath);

      // Write to the file
      await file.writeAsString(csv.join('\n'));
    } on CacheException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<List> getDataFromCSV() async {
    try {
      List<TimingModel> timings = [];
      List<TPSModel> tpss = [];
      List<RPMModel> rpms = [];

      final loadedPath = await _filePicker.pickFiles(
        allowedExtensions: ['csv'],
        type: FileType.custom,
        lockParentWindow: true,
      );

      if (loadedPath == null) {
        throw const CacheException(message: 'No path was found');
      }

      final file = File(loadedPath.files.single.path!);
      final upcomingDataString = await file.readAsString();

      String timingsList = "";
      String tpssList = "";
      String rpmsList = "";

      // tpssList
      tpssList =
          upcomingDataString.split('\n')[0].split(',').sublist(1, 30).join('');
      tpssList = tpssList.replaceAll('FFFF', '');

      // rpmsList
      for (int i = 29; i >= 0; i--) {
        rpmsList += upcomingDataString.split('\n')[i + 1].split(',')[0];
      }
      rpmsList = rpmsList.replaceAll('FFFF', '');

      // timingsList
      for (int i = 29; i >= 0; i--) {
        for (int j = 0; j < 30; j++) {
          timingsList +=
              upcomingDataString.split('\n')[i + 1].split(',')[j + 1];
        }
      }
      timingsList = timingsList.replaceAll('FFFF', '');

      for (int i = 0; i < tpssList.length / 4; i++) {
        tpss.add(
          TPSModel(
            id: i,
            isFirst: i == 0,
            isLast: i == tpssList.length / 4 - 1,
            value: CoreUtils.hexToDouble(tpssList.substring(i * 4, i * 4 + 4)) /
                1000,
            prevValue: i == 0
                ? null
                : CoreUtils.hexToDouble(tpssList.substring(i * 4 - 4, i * 4)) /
                    1000,
            nextValue: i == tpssList.length / 4 - 1
                ? null
                : CoreUtils.hexToDouble(
                        tpssList.substring(i * 4 + 4, i * 4 + 8)) /
                    1000,
          ),
        );
      }

      for (int i = 0; i < rpmsList.length / 4; i++) {
        rpms.add(
          RPMModel(
            id: i,
            isFirst: i == 0,
            isLast: i == rpmsList.length / 4 - 1,
            value: CoreUtils.hexToDouble(rpmsList.substring(i * 4, i * 4 + 4)),
            prevValue: i == 0
                ? null
                : CoreUtils.hexToDouble(rpmsList.substring(i * 4 - 4, i * 4)),
            nextValue: i == rpmsList.length / 4 - 1
                ? null
                : CoreUtils.hexToDouble(
                    rpmsList.substring(i * 4 + 4, i * 4 + 8)),
          ),
        );
      }

      timings = List.generate(
        tpss.length * rpms.length,
        (index) {
          int i = index % tpss.length;
          int j = index ~/ tpss.length;
          return TimingModel(
            id: index,
            tpsValue: tpss[i].value,
            mintpsValue: (i > 0)
                ? (tpss[i - 1].value + tpss[i].value) / 2
                : tpss[0].value,
            maxtpsValue: (i < tpss.length - 1)
                ? (tpss[i].value + tpss[i + 1].value) / 2
                : tpss[tpss.length - 1].value,
            rpmValue: rpms[j].value,
            minrpmValue: (j > 0)
                ? (rpms[j - 1].value + rpms[j].value) / 2
                : rpms[0].value,
            maxrpmValue: (j < rpms.length - 1)
                ? (rpms[j].value + rpms[j + 1].value) / 2
                : rpms[rpms.length - 1].value,
            value: CoreUtils.hexToDouble(
                    timingsList.substring(index * 4, index * 4 + 4)) /
                100,
          );
        },
      );

      return [
        timings,
        tpss,
        rpms,
      ];
    } on CacheException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw CacheException(message: e.toString());
    }
  }
}
