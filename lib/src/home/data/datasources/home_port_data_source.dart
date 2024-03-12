import 'dart:async';
import 'package:ddfapp/core/utils/core_utils.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:get/get.dart';
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

  Stream<String> getFeedbackValue({
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
                portsValues.add(
                    double.tryParse(CoreUtils.hexToDoubleString(value)) ?? 0);
                type = '';
              } else if (type == 'FFFB' &&
                  portsValues.isNotEmpty &&
                  value.length == 4) {
                portsValues.add(
                    double.tryParse(CoreUtils.hexToDoubleString(value)) ?? 0);
                controllerDataSource.add(List<double>.from(portsValues));
                print('Values: $portsValues');
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
      SerialPortReader serialPortReader = SerialPortReader(serialPort);
      if (!serialPort.isOpen) {
        serialPort.close();
      }
      if (serialPortReader.isBlank ?? true) {
        print('Stream is closed');
        throw const PortException(message: 'Stream is closed');
      }
      Stream upcomingData = serialPortReader.stream.map(
        (data) => data,
      );

      List<double> listDouble = [
        CoreUtils.hexToDouble('FFFA'),
        ...tpss.map((e) => e.value).toList(),
        for (int i = tpss.length; i < 30; i++) CoreUtils.hexToDouble('FFFF'),
        CoreUtils.hexToDouble('FFFB'),
        ...rpms.map((e) => e.value).toList(),
        for (int i = rpms.length; i < 30; i++) CoreUtils.hexToDouble('FFFF'),
        CoreUtils.hexToDouble('FFFC'),
        ...timings.map((e) => e.value).toList(),
        for (int i = timings.length; i < 900; i++)
          CoreUtils.hexToDouble('FFFF'),
      ];

      final valueSend = CoreUtils.listDoubleToHexadecimal(listDouble);
      print('ValueSend: $valueSend');

      for (int i = 0; i < 107; i++) {
        Future.delayed(Duration(milliseconds: 50 * i), () {
          final bytesData =
              CoreUtils.hexaToBytes(valueSend.substring(i * 36, (i + 1) * 36));
          final result = serialPort.write(bytesData);

          print('Result: $result');
        });
      }

      String value = '';

      upcomingData.forEach((element) {
        try {
          String input = String.fromCharCodes(element);
          value += input;
        } catch (e) {
          print('Error-Value: $value');
          throw PortException(message: e.toString());
        }
      });
      await Future.delayed(const Duration(milliseconds: 50 * 108), () {
        print('Value: $value');
        print('Stream is closed');
        serialPortReader.close();
        serialPort.close();
        serialPort.dispose();
      });
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
        bytesData = CoreUtils.hexaToBytes('FFFD');
      } else {
        bytesData = CoreUtils.hexaToBytes('FFFE');
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

  @override
  Stream<String> getFeedbackValue(
      {required SerialPortReader serialPortReader}) async* {
    try {
      final StreamController<String> controllerDataSource =
          StreamController<String>();

      Stream upcomingData = serialPortReader.stream.map(
        (data) => data,
      );

      String mod = '';
      String char = '';
      String value = '';
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
              if (value.length == 4) {
                controllerDataSource.add(value);
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
}
