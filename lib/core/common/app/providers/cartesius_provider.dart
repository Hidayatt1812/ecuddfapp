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
    if (_rpms != rpms) {
      _rpms = rpms;

      Future.delayed(Duration.zero, notifyListeners);
    }
  }

  void setRpmById(int index, double value) {
    if (index != -1) {
      final RPM prevRpm = index > 0 ? _rpms[index - 1] : _rpms[index];
      final RPM nextRpm =
          index < _rpms.length - 1 ? _rpms[index + 1] : _rpms[index];
      _rpms[index] = RPM(
        id: _rpms[index].id,
        isFirst: _rpms[index].isFirst,
        isLast: _rpms[index].isLast,
        value: value,
        prevValue: prevRpm.value,
        nextValue: nextRpm.value,
      );
      int j = index;
      for (int i = 0; i < _tpss.length; i++) {
        print('rpm[index]: ${i + j * _rpms.length}');
        _timings[i + j * _rpms.length] = Timing(
          id: i + j * _rpms.length,
          tpsValue: _timings[i + j * _rpms.length].tpsValue,
          mintpsValue: _timings[i + j * _rpms.length].mintpsValue,
          maxtpsValue: _timings[i + j * _rpms.length].maxtpsValue,
          rpmValue: _rpms[j].value,
          minrpmValue: index == 0 ? value : (prevRpm.value + value) / 2,
          maxrpmValue:
              index == _rpms.length - 1 ? value : (nextRpm.value + value) / 2,
          value: 1,
        );
      }
      if (index > 0) {
        _rpms[index - 1] = RPM(
          id: prevRpm.id,
          isFirst: prevRpm.isFirst,
          isLast: prevRpm.isLast,
          value: prevRpm.value,
          prevValue: prevRpm.prevValue,
          nextValue: value,
        );
        for (int i = 0; i < _tpss.length; i++) {
          _timings[i + (j - 1) * _rpms.length] = Timing(
            id: i + (j - 1) * _rpms.length,
            tpsValue: _timings[i + (j - 1) * _rpms.length].tpsValue,
            mintpsValue: _timings[i + (j - 1) * _rpms.length].mintpsValue,
            maxtpsValue: _timings[i + (j - 1) * _rpms.length].maxtpsValue,
            rpmValue: _timings[i + (j - 1) * _rpms.length].rpmValue,
            minrpmValue: _timings[i + (j - 1) * _rpms.length].minrpmValue,
            maxrpmValue:
                (_timings[i + (j - 1) * _rpms.length].rpmValue + value) / 2,
            value: 1,
          );
        }
      }
      if (index < _rpms.length - 1) {
        _rpms[index + 1] = RPM(
          id: nextRpm.id,
          isFirst: nextRpm.isFirst,
          isLast: nextRpm.isLast,
          value: nextRpm.value,
          prevValue: value,
          nextValue: nextRpm.nextValue,
        );
        for (int i = 0; i < _tpss.length; i++) {
          _timings[i + (j + 1) * _rpms.length] = Timing(
            id: i + (j + 1) * _rpms.length,
            tpsValue: _timings[i + (j + 1) * _rpms.length].tpsValue,
            mintpsValue: _timings[i + (j + 1) * _rpms.length].mintpsValue,
            maxtpsValue: _timings[i + (j + 1) * _rpms.length].maxtpsValue,
            rpmValue: _timings[i + (j + 1) * _rpms.length].rpmValue,
            minrpmValue:
                (_timings[i + (j + 1) * _rpms.length].rpmValue + value) / 2,
            maxrpmValue: _timings[i + (j + 1) * _rpms.length].maxrpmValue,
            value: 1,
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
    if (_tpss != tpss) {
      _tpss = tpss;
      Future.delayed(Duration.zero, notifyListeners);
    }
  }

  void setTpsById(int index, double value) {
    if (index != -1) {
      final TPS prevTps = index > 0 ? _tpss[index - 1] : _tpss[index];
      final TPS nextTps =
          index < _tpss.length - 1 ? _tpss[index + 1] : _tpss[index];
      _tpss[index] = TPS(
        id: _tpss[index].id,
        isFirst: _tpss[index].isFirst,
        isLast: _tpss[index].isLast,
        value: value,
        prevValue: prevTps.value,
        nextValue: nextTps.value,
      );
      int i = index;
      for (int j = 0; j < _rpms.length; j++) {
        _timings[i + j * _rpms.length] = Timing(
          id: i + j * _rpms.length,
          tpsValue: _tpss[i].value,
          mintpsValue: index == 0 ? value : (prevTps.value + value) / 2,
          maxtpsValue:
              index == _tpss.length - 1 ? value : (nextTps.value + value) / 2,
          rpmValue: _timings[i + j * _rpms.length].rpmValue,
          minrpmValue: _timings[i + j * _rpms.length].minrpmValue,
          maxrpmValue: _timings[i + j * _rpms.length].maxrpmValue,
          value: 1,
        );
      }
      if (index > 0) {
        _tpss[index - 1] = TPS(
          id: prevTps.id,
          isFirst: prevTps.isFirst,
          isLast: prevTps.isLast,
          value: prevTps.value,
          prevValue: prevTps.prevValue,
          nextValue: value,
        );
        for (int j = 0; j < _rpms.length; j++) {
          _timings[(i + j * _rpms.length) - 1] = Timing(
            id: (i + j * _rpms.length) - 1,
            tpsValue: _timings[(i + j * _rpms.length) - 1].tpsValue,
            mintpsValue: _timings[(i + j * _rpms.length) - 1].mintpsValue,
            maxtpsValue:
                (_timings[(i + j * _rpms.length) - 1].tpsValue + value) / 2,
            rpmValue: _timings[(i + j * _rpms.length) - 1].rpmValue,
            minrpmValue: _timings[(i + j * _rpms.length) - 1].minrpmValue,
            maxrpmValue: _timings[(i + j * _rpms.length) - 1].maxrpmValue,
            value: 1,
          );
        }
      }
      if (index < _tpss.length - 1) {
        _tpss[index + 1] = TPS(
          id: nextTps.id,
          isFirst: nextTps.isFirst,
          isLast: nextTps.isLast,
          value: nextTps.value,
          prevValue: value,
          nextValue: nextTps.nextValue,
        );
        for (int j = 0; j < _rpms.length; j++) {
          _timings[(i + j * _rpms.length) + 1] = Timing(
            id: (i + j * _rpms.length) + 1,
            tpsValue: _timings[(i + j * _rpms.length) + 1].tpsValue,
            mintpsValue:
                (_timings[(i + j * _rpms.length) + 1].tpsValue + value) / 2,
            maxtpsValue: _timings[(i + j * _rpms.length) + 1].maxtpsValue,
            rpmValue: _timings[(i + j * _rpms.length) + 1].rpmValue,
            minrpmValue: _timings[(i + j * _rpms.length) + 1].minrpmValue,
            maxrpmValue: _timings[(i + j * _rpms.length) + 1].maxrpmValue,
            value: 1,
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
      return Timing(
        id: index,
        tpsValue: i.toDouble(),
        mintpsValue: (i > 0) ? ((i - 1) + i) / 2 : 0,
        maxtpsValue: (i < 9) ? (i + (i + 1)) / 2 : 9,
        rpmValue: j.toDouble(),
        minrpmValue: (j > 0) ? ((j - 1) + j) / 2 : 0,
        maxrpmValue: (j < 9) ? (j + (j + 1)) / 2 : 9,
        value: 1,
      );
    },
  );

  List<Timing> get timings => _timings;

  void initTiming(List<Timing> timings) {
    if (_timings != timings) {
      _timings = timings;
      Future.delayed(Duration.zero, notifyListeners);
    }
  }
}
