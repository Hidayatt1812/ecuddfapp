import 'package:flutter/cupertino.dart';

import '../../../../src/home/domain/entities/rpm.dart';
import '../../../../src/home/domain/entities/tps.dart';

class CartesiusProvider extends ChangeNotifier {
  RPM _rpm = const RPM.empty();

  RPM get rpm => _rpm;

  void initRpm(RPM rpm) {
    if (_rpm != rpm) {
      _rpm = rpm;
      Future.delayed(Duration.zero, notifyListeners);
    }
  }

  TPS _tps = const TPS.empty();

  TPS get tps => _tps;

  void initTps(TPS tps) {
    if (_tps != tps) {
      _tps = tps;
      Future.delayed(Duration.zero, notifyListeners);
    }
  }

  List<RPM> _rpms = [];

  List<RPM> get rpms => _rpms;

  void initRpms(List<RPM> rpms) {
    if (_rpms != rpms) {
      _rpms = rpms;
      Future.delayed(Duration.zero, notifyListeners);
    }
  }

  RPM getRpmById(int id) {
    return _rpms.firstWhere((element) => element.id == id);
  }

  void setRpmValueById(int id, double value) {
    _rpms = _rpms.map((e) {
      if (e.id == id) {
        return RPM(
          id: e.id,
          minValue: e.minValue,
          maxValue: e.maxValue,
          interval: e.interval,
          steps: e.steps,
          value: value,
        );
      }
      return e;
    }).toList();
    notifyListeners();
  }
}
