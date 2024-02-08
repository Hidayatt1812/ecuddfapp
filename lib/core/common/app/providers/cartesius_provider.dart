import 'package:ddfapp/src/home/data/models/rpm_model.dart';
import 'package:ddfapp/src/home/data/models/timing_model.dart';
import 'package:ddfapp/src/home/data/models/tps_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../../src/home/domain/entities/rpm.dart';
import '../../../../src/home/domain/entities/timing.dart';
import '../../../../src/home/domain/entities/tps.dart';

class CartesiusProvider extends ChangeNotifier {
  List<RPM> _rpms = List.generate(
      10,
      (index) => RPM(
            id: index,
            isFirst: index == 0,
            isLast: index == 9,
            value: index.toDouble(),
            prevValue: index == 0 ? null : (index - 1).toDouble(),
            nextValue: index == 9 ? null : (index + 1).toDouble(),
          ));

  List<RPM> get rpms => _rpms;

  void initRpms(List<RPM> rpms) {
    _rpms = rpms;
    resetTiming();
    setTpsRPMLinesValue(_tpsValue, _rpmValue);
    Future.delayed(Duration.zero, notifyListeners);
  }

  void setRpmById(int index, double value) {
    if (index != -1) {
      final RPM prevRpm = index > 0 ? _rpms[index - 1] : _rpms[index];
      final RPM nextRpm =
          index < _rpms.length - 1 ? _rpms[index + 1] : _rpms[index];
      _rpms[index] = RPMModel(
        id: _rpms[index].id,
        isFirst: _rpms[index].isFirst,
        isLast: _rpms[index].isLast,
        value: value,
        prevValue: prevRpm.value,
        nextValue: nextRpm.value,
      );
      int j = index;
      for (int i = 0; i < _tpss.length; i++) {
        _timings[i + j * _tpss.length] = TimingModel(
          id: i + j * _tpss.length,
          tpsValue: _timings[i + j * _tpss.length].tpsValue,
          mintpsValue: _timings[i + j * _tpss.length].mintpsValue,
          maxtpsValue: _timings[i + j * _tpss.length].maxtpsValue,
          rpmValue: _rpms[j].value,
          minrpmValue: index == 0 ? value : (prevRpm.value + value) / 2,
          maxrpmValue:
              index == _tpss.length - 1 ? value : (nextRpm.value + value) / 2,
          value: _timings[i + j * _tpss.length].value,
        );
      }
      if (index > 0) {
        _rpms[index - 1] = RPMModel(
          id: prevRpm.id,
          isFirst: prevRpm.isFirst,
          isLast: prevRpm.isLast,
          value: prevRpm.value,
          prevValue: prevRpm.prevValue,
          nextValue: value,
        );
        for (int i = 0; i < _tpss.length; i++) {
          _timings[i + (j - 1) * _tpss.length] = TimingModel(
            id: i + (j - 1) * _tpss.length,
            tpsValue: _timings[i + (j - 1) * _tpss.length].tpsValue,
            mintpsValue: _timings[i + (j - 1) * _tpss.length].mintpsValue,
            maxtpsValue: _timings[i + (j - 1) * _tpss.length].maxtpsValue,
            rpmValue: _timings[i + (j - 1) * _tpss.length].rpmValue,
            minrpmValue: _timings[i + (j - 1) * _tpss.length].minrpmValue,
            maxrpmValue:
                (_timings[i + (j - 1) * _tpss.length].rpmValue + value) / 2,
            value: _timings[i + (j - 1) * _tpss.length].value,
          );
        }
      }
      if (index < _rpms.length - 1) {
        _rpms[index + 1] = RPMModel(
          id: nextRpm.id,
          isFirst: nextRpm.isFirst,
          isLast: nextRpm.isLast,
          value: nextRpm.value,
          prevValue: value,
          nextValue: nextRpm.nextValue,
        );
        for (int i = 0; i < _tpss.length; i++) {
          _timings[i + (j + 1) * _tpss.length] = TimingModel(
            id: i + (j + 1) * _tpss.length,
            tpsValue: _timings[i + (j + 1) * _tpss.length].tpsValue,
            mintpsValue: _timings[i + (j + 1) * _tpss.length].mintpsValue,
            maxtpsValue: _timings[i + (j + 1) * _tpss.length].maxtpsValue,
            rpmValue: _timings[i + (j + 1) * _tpss.length].rpmValue,
            minrpmValue:
                (_timings[i + (j + 1) * _tpss.length].rpmValue + value) / 2,
            maxrpmValue: _timings[i + (j + 1) * _tpss.length].maxrpmValue,
            value: _timings[i + (j + 1) * _tpss.length].value,
          );
        }
      }
      notifyListeners();
    }
  }

  List<TPS> _tpss = List.generate(
      10,
      (index) => TPS(
            id: index,
            isFirst: index == 0,
            isLast: index == 9,
            value: index.toDouble(),
            prevValue: index == 0 ? null : (index - 1).toDouble(),
            nextValue: index == 9 ? null : (index + 1).toDouble(),
          ));

  List<TPS> get tpss => _tpss;

  void initTpss(List<TPS> tpss) {
    _tpss = tpss;
    resetTiming();
    setTpsRPMLinesValue(_tpsValue, _rpmValue);
    Future.delayed(Duration.zero, notifyListeners);
  }

  void setTpsById(int index, double value) {
    if (index != -1) {
      final TPS prevTps = index > 0 ? _tpss[index - 1] : _tpss[index];
      final TPS nextTps =
          index < _tpss.length - 1 ? _tpss[index + 1] : _tpss[index];
      _tpss[index] = TPSModel(
        id: _tpss[index].id,
        isFirst: _tpss[index].isFirst,
        isLast: _tpss[index].isLast,
        value: value,
        prevValue: prevTps.value,
        nextValue: nextTps.value,
      );
      int i = index;
      for (int j = 0; j < _rpms.length; j++) {
        _timings[i + j * _tpss.length] = TimingModel(
          id: i + j * _tpss.length,
          tpsValue: _tpss[i].value,
          mintpsValue: index == 0 ? value : (prevTps.value + value) / 2,
          maxtpsValue:
              index == _tpss.length - 1 ? value : (nextTps.value + value) / 2,
          rpmValue: _timings[i + j * _tpss.length].rpmValue,
          minrpmValue: _timings[i + j * _tpss.length].minrpmValue,
          maxrpmValue: _timings[i + j * _tpss.length].maxrpmValue,
          value: _timings[i + j * _tpss.length].value,
        );
      }
      if (index > 0) {
        _tpss[index - 1] = TPSModel(
          id: prevTps.id,
          isFirst: prevTps.isFirst,
          isLast: prevTps.isLast,
          value: prevTps.value,
          prevValue: prevTps.prevValue,
          nextValue: value,
        );
        for (int j = 0; j < _rpms.length; j++) {
          _timings[(i + j * _tpss.length) - 1] = TimingModel(
            id: (i + j * _tpss.length) - 1,
            tpsValue: _timings[(i + j * _tpss.length) - 1].tpsValue,
            mintpsValue: _timings[(i + j * _tpss.length) - 1].mintpsValue,
            maxtpsValue:
                (_timings[(i + j * _tpss.length) - 1].tpsValue + value) / 2,
            rpmValue: _timings[(i + j * _tpss.length) - 1].rpmValue,
            minrpmValue: _timings[(i + j * _tpss.length) - 1].minrpmValue,
            maxrpmValue: _timings[(i + j * _tpss.length) - 1].maxrpmValue,
            value: _timings[(i + j * _tpss.length) - 1].value,
          );
        }
      }
      if (index < _tpss.length - 1) {
        _tpss[index + 1] = TPSModel(
          id: nextTps.id,
          isFirst: nextTps.isFirst,
          isLast: nextTps.isLast,
          value: nextTps.value,
          prevValue: value,
          nextValue: nextTps.nextValue,
        );
        for (int j = 0; j < _rpms.length; j++) {
          _timings[(i + j * _tpss.length) + 1] = TimingModel(
            id: (i + j * _tpss.length) + 1,
            tpsValue: _timings[(i + j * _tpss.length) + 1].tpsValue,
            mintpsValue:
                (_timings[(i + j * _tpss.length) + 1].tpsValue + value) / 2,
            maxtpsValue: _timings[(i + j * _tpss.length) + 1].maxtpsValue,
            rpmValue: _timings[(i + j * _tpss.length) + 1].rpmValue,
            minrpmValue: _timings[(i + j * _tpss.length) + 1].minrpmValue,
            maxrpmValue: _timings[(i + j * _tpss.length) + 1].maxrpmValue,
            value: _timings[(i + j * _tpss.length) + 1].value,
          );
        }
      }
      notifyListeners();
    }
  }

  List<Timing> _timings = List.generate(
    100,
    (index) {
      int i = index % 10;
      int j = index ~/ 10;
      return TimingModel(
        id: index,
        tpsValue: i.toDouble(),
        mintpsValue: (i > 0) ? ((i - 1) + i) / 2 : 0,
        maxtpsValue: (i < 9) ? (i + (i + 1)) / 2 : 9,
        rpmValue: j.toDouble(),
        minrpmValue: (j > 0) ? ((j - 1) + j) / 2 : 0,
        maxrpmValue: (j < 9) ? (j + (j + 1)) / 2 : 9,
        value: 0,
      );
    },
  );

  List<Timing> get timings => _timings;

  void initTimings(List<Timing> timings) {
    if (_timings != timings) {
      _timings = timings;
      Future.delayed(Duration.zero, notifyListeners);
    }
  }

  void resetTiming() {
    _timings = List.generate(
      _tpss.length * _rpms.length,
      (index) {
        int i = index % _tpss.length;
        int j = index ~/ _tpss.length;
        return Timing(
          id: index,
          tpsValue: _tpss[i].value,
          mintpsValue: (i > 0)
              ? (_tpss[i - 1].value + _tpss[i].value) / 2
              : _tpss[0].value,
          maxtpsValue: (i < _tpss.length - 1)
              ? (_tpss[i].value + _tpss[i + 1].value) / 2
              : _tpss[_tpss.length - 1].value,
          rpmValue: _rpms[j].value,
          minrpmValue: (j > 0)
              ? (_rpms[j - 1].value + _rpms[j].value) / 2
              : _rpms[0].value,
          maxrpmValue: (j < _rpms.length - 1)
              ? (_rpms[j].value + _rpms[j + 1].value) / 2
              : _rpms[_rpms.length - 1].value,
          value: 0,
        );
      },
    );
    notifyListeners();
  }

  List<int> _idsTiming = [];

  List<int> get idsTimings => _idsTiming;

  void setIdsTiming() {
    if (_idStartTiming != null && _idEndTiming != null) {
      int i = _idStartTiming! % _tpss.length; //b
      int j = _idStartTiming! ~/ _tpss.length; //a

      int x = _idEndTiming! % _tpss.length; //Y
      int y = _idEndTiming! ~/ _tpss.length; //X

      if (x >= i && y >= j) {
        for (int k = j; k <= y; k++) {
          for (int l = i; l <= x; l++) {
            _idsTiming.add(l + k * _tpss.length);
          }
        }
      } else if (x >= i && y < j) {
        for (int k = y; k <= j; k++) {
          for (int l = i; l <= x; l++) {
            _idsTiming.add(l + k * _tpss.length);
          }
        }
      } else if (x < i && y >= j) {
        for (int k = j; k <= y; k++) {
          for (int l = x; l <= i; l++) {
            _idsTiming.add(l + k * _tpss.length);
          }
        }
      } else if (x < i && y < j) {
        for (int k = y; k <= j; k++) {
          for (int l = x; l <= i; l++) {
            _idsTiming.add(l + k * _tpss.length);
          }
        }
      }
      Future.delayed(Duration.zero, notifyListeners);
    }
  }

  void resetIdsTiming() {
    _idsTiming = [];
    notifyListeners();
  }

  int? _idStartTiming;

  int? get idStartTiming => _idStartTiming;

  void setIdStartTiming(int? id) {
    if (_idStartTiming != id) {
      _idStartTiming = id;
      Future.delayed(Duration.zero, notifyListeners);
    }
  }

  int? _idEndTiming;

  int? get idEndTiming => _idEndTiming;

  void setIdEndTiming(int? id) {
    if (_idEndTiming != id) {
      _idEndTiming = id;
      resetIdsTiming();
      setIdsTiming();
      Future.delayed(Duration.zero, notifyListeners);
    }
  }

  bool _isSelectingTiming = false;

  bool get isSelectingTiming => _isSelectingTiming;

  void setIsSelectingTiming(bool value) {
    if (_isSelectingTiming != value) {
      _isSelectingTiming = value;
      Future.delayed(Duration.zero, notifyListeners);
    }
  }

  double? _valueTiming;

  double? get valueTiming => _valueTiming;

  void setValueTiming(double? value) {
    if (_valueTiming != value) {
      _valueTiming = value;
      Future.delayed(Duration.zero, notifyListeners);
    }
  }

  double? _tpsLinesValue;

  double? get tpsLinesValue => _tpsLinesValue;

  double? _rpmLinesValue;

  double? get rpmLinesValue => _rpmLinesValue;

  double _tpsValue = 0;

  double get tpsValue => _tpsValue;

  double _rpmValue = 0;

  double get rpmValue => _rpmValue;

  void setTpsRPMLinesValue(double valueLinesTps, double valueLinesRpm) {
    _tpsValue = valueLinesTps;
    _rpmValue = valueLinesRpm;
    int tpsIndex = -1;
    int rpmIndex = -1;
    for (int i = 0; i < _timings.length; i++) {
      if (valueLinesTps >= _timings[i].mintpsValue &&
          valueLinesTps <= _timings[i].maxtpsValue) {
        _tpsLinesValue = (((valueLinesTps - _timings[i].mintpsValue) /
                    (_timings[i].maxtpsValue - _timings[i].mintpsValue)) +
                i % _tpss.length) /
            (_tpss.length);
        tpsIndex = i % _tpss.length;
        break;
      }
    }

    for (int i = 0; i < _timings.length; i += _tpss.length) {
      if (valueLinesRpm >= _timings[i].minrpmValue &&
          valueLinesRpm <= _timings[i].maxrpmValue) {
        _rpmLinesValue = (((valueLinesRpm - _timings[i].minrpmValue) /
                    (_timings[i].maxrpmValue - _timings[i].minrpmValue)) +
                i ~/ _tpss.length) /
            (_rpms.length);
        rpmIndex = i ~/ _tpss.length;
        break;
      }
    }
    if (tpsIndex != -1 && rpmIndex != -1) {
      setValueTiming(_timings[tpsIndex + (rpmIndex * _tpss.length)].value);
    }

    Future.delayed(Duration.zero, notifyListeners);
  }

  void defaultAll() {
    _rpms = List.generate(
        10,
        (index) => RPMModel(
              id: index,
              isFirst: index == 0,
              isLast: index == 9,
              value: index.toDouble(),
              prevValue: index == 0 ? null : (index - 1).toDouble(),
              nextValue: index == 9 ? null : (index + 1).toDouble(),
            ));

    _tpss = List.generate(
        10,
        (index) => TPSModel(
              id: index,
              isFirst: index == 0,
              isLast: index == 9,
              value: index.toDouble(),
              prevValue: index == 0 ? null : (index - 1).toDouble(),
              nextValue: index == 9 ? null : (index + 1).toDouble(),
            ));

    _timings = List.generate(
      100,
      (index) {
        int i = index % 10;
        int j = index ~/ 10;
        return TimingModel(
          id: index,
          tpsValue: i.toDouble(),
          mintpsValue: (i > 0) ? ((i - 1) + i) / 2 : 0,
          maxtpsValue: (i < 9) ? (i + (i + 1)) / 2 : 9,
          rpmValue: j.toDouble(),
          minrpmValue: (j > 0) ? ((j - 1) + j) / 2 : 0,
          maxrpmValue: (j < 9) ? (j + (j + 1)) / 2 : 9,
          value: 0,
        );
      },
    );
    notifyListeners();
  }
}
