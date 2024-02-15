import 'dart:async';
import 'package:ddfapp/core/utils/core_utils.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
// import 'package:serial_port_win32/serial_port_win32.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/rpm_model.dart';
import '../models/timing_model.dart';
import '../models/tps_model.dart';

abstract class HomePortDataSource {
  const HomePortDataSource();

  Stream<List<double>> getTPSRPMLinesValue({
    required SerialPortReader serialPortReader,
  });

  Future<List<String>> getPorts();

  Future<void> sendDataToECU({
    required SerialPort serialPort,
    required List<TPSModel> tpss,
    required List<RPMModel> rpms,
    required List<TimingModel> timings,
  });

  Future<void> switchPower({
    required SerialPort serialPort,
    required bool status,
  });
}

class HomePortDataSourceImpl implements HomePortDataSource {
  const HomePortDataSourceImpl();

  @override
  Stream<List<double>> getTPSRPMLinesValue({
    required SerialPortReader serialPortReader,
  }) async* {
    try {
      final StreamController<List<double>> controllerDataSource =
          StreamController<List<double>>();

      Stream upcomingData = serialPortReader.stream.map(
        (data) => data,
      );

      String type = '';
      String mod = '';
      String char = '';
      String value = '';
      List<double> portsValues = [];
      StreamSubscription subscription = upcomingData.listen(
        (data) {
          try {
            String input = String.fromCharCodes(data);
            if (input.length <= 4) {
              input = mod + input;
              mod = '';
              for (int i = 0; i < input.length; i++) {
                char = input[i];
                if (value.length < 4) {
                  value += char;
                } else {
                  mod += char;
                }
              }
              if (type == 'FFFA' && value.length == 4) {
                portsValues
                    .add(double.tryParse(CoreUtils.hexToDouble(value)) ?? 0);
                type = '';
              } else if (type == 'FFFB' &&
                  portsValues.isNotEmpty &&
                  value.length == 4) {
                portsValues
                    .add(double.tryParse(CoreUtils.hexToDouble(value)) ?? 0);
                controllerDataSource.add(List<double>.from(portsValues));
                portsValues.clear();
                type = '';
              } else if (value.length == 4) {
                if (value == 'FFFA' || value == 'FFFB') {
                  type = value;
                }
                value = '';
              }
            }
          } catch (e) {
            throw PortException(message: e.toString());
          }
        },
        onError: (e, s) {
          debugPrintStack(stackTrace: s);
          controllerDataSource.close();
        },
        onDone: () {
          controllerDataSource.close();
        },
        cancelOnError: true,
      );

      if (controllerDataSource.isClosed) {
        subscription.cancel();
        throw const PortException(message: 'Stream is closed');
      }
      yield* controllerDataSource.stream;
    } on PortException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw PortException(message: e.toString());
    }
  }

  @override
  Future<List<String>> getPorts() async {
    try {
      final ports = SerialPort.availablePorts;
      if (ports.isEmpty) {
        throw const PortException(message: 'No Available Ports were found');
      }
      return ports;
    } on PortException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw PortException(message: e.toString());
    }
  }

  @override
  Future<void> sendDataToECU({
    required SerialPort serialPort,
    required List<TPSModel> tpss,
    required List<RPMModel> rpms,
    required List<TimingModel> timings,
  }) async {
    try {
      final listDouble = [
        ...tpss.map((e) => e.value).toList(),
        ...rpms.map((e) => e.value).toList(),
        ...timings.map((e) => e.value).toList(),
      ];

      final value = CoreUtils.listDoubleToHexadecimal(listDouble);
      final bytesData = CoreUtils.hexaToBytes(value);
      final result = serialPort.write(bytesData);
      print('Result: $result');
    } on PortException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw PortException(message: e.toString());
    }
  }

  @override
  Future<void> switchPower({
    required SerialPort serialPort,
    required bool status,
  }) async {
    try {
      dynamic bytesData;
      if (status) {
        bytesData = CoreUtils.hexaToBytes('FFFE');
      } else {
        bytesData = CoreUtils.hexaToBytes('FFFF');
      }
      final result = serialPort.write(bytesData);
      print('Result: $result');
    } on PortException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw PortException(message: e.toString());
    }
  }
}
