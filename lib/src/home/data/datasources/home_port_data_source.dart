import 'dart:async';
import 'dart:developer';
import 'package:ddfapp/core/utils/core_utils.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

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
    required bool status,
  });

  Future<void> switchPower({
    required SerialPort serialPort,
    required List<TPSModel> tpss,
    required List<RPMModel> rpms,
    required List<TimingModel> timings,
    required bool status,
  });

  Future<List<dynamic>> getDataFromECU({
    required SerialPort serialPort,
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

      String mod = '';
      String char = '';
      String value = '';
      List<double> portsValues = [];
      StreamSubscription subscription = upcomingData.listen(
        (data) {
          log(String.fromCharCodes(data));
          try {
            String input = String.fromCharCodes(data);
            input = CoreUtils.removeHexaChar(input);
            if (input.length <= 16) {
              input = mod + input;
              mod = '';
              for (int i = 0; i < input.length; i++) {
                char = input[i];
                if (value.length < 16) {
                  value += char;
                } else {
                  mod += char;
                }
              }
            }
            if (value.length == 16 && CoreUtils.isHexadecimal(value)) {
              portsValues.add((double.tryParse(
                        CoreUtils.hexToDoubleString(value.substring(4, 8)),
                      ) ??
                      0) /
                  4096 *
                  3.3);
              portsValues.add(double.tryParse(
                      CoreUtils.hexToDoubleString(value.substring(12, 16))) ??
                  0);
              controllerDataSource.add(List<double>.from(portsValues));
              portsValues.clear();
              value = '';
            }
            // if (input.length <= 4) {
            //   input = mod + input;
            //   mod = '';
            //   for (int i = 0; i < input.length; i++) {
            //     char = input[i];
            //     if (value.length < 4) {
            //       value += char;
            //     } else {
            //       mod += char;
            //     }
            //   }
            //   if (type == 'FFFA' && value.length == 4) {
            //     portsValues.add(
            //         double.tryParse(CoreUtils.hexToDoubleString(value)) ?? 0);
            //     type = '';
            //   } else if (type == 'FFFB' &&
            //       portsValues.isNotEmpty &&
            //       value.length == 4) {
            //     portsValues.add(
            //         double.tryParse(CoreUtils.hexToDoubleString(value)) ?? 0);
            //     controllerDataSource.add(List<double>.from(portsValues));
            //     print('Values: $portsValues');
            //     portsValues.clear();
            //     type = '';
            //   } else if (value.length == 4) {
            //     if (value == 'FFFA' || value == 'FFFB') {
            //       type = value;
            //     }
            //     value = '';
            //   }
            // }
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
    required bool status,
  }) async {
    try {
      if (!serialPort.isOpen) {
        serialPort.close();
      }

      List<double> listDouble = [
        CoreUtils.hexToDouble('FFFA'),
        ...tpss.map((e) => e.value * 4096 / 3.3).toList(),
        for (int i = tpss.length; i < 30; i++) CoreUtils.hexToDouble('FFFF'),
        CoreUtils.hexToDouble('FFFB'),
        ...rpms.map((e) => e.value).toList(),
        for (int i = rpms.length; i < 30; i++) CoreUtils.hexToDouble('FFFF'),
        CoreUtils.hexToDouble('FFFC'),
        ...timings.map((e) => e.value).toList(),
        for (int i = timings.length; i < 900; i++)
          CoreUtils.hexToDouble('FFFF'),
        status ? CoreUtils.hexToDouble('FFFD') : CoreUtils.hexToDouble('FFFE'),
      ];

      final valueSend = "FFFW${CoreUtils.listDoubleToHexadecimal(listDouble)}";

      for (int i = 0; i < 107; i++) {
        await Future.delayed(const Duration(milliseconds: 30), () {
          final bytesData =
              CoreUtils.hexaToBytes(valueSend.substring(i * 36, (i + 1) * 36));
          final result = serialPort.write(bytesData);

          log('Result: $result');
        });
      }
      await Future.delayed(const Duration(milliseconds: 10), () {
        final bytesData = CoreUtils.hexaToBytes(
            valueSend.substring(107 * 36, (107) * 36 + 8));
        final result = serialPort.write(bytesData);

        log('Result: $result');
      });
      await Future.delayed(const Duration(milliseconds: 2000), () {
        log('Stream is closed');
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
    required List<TPSModel> tpss,
    required List<RPMModel> rpms,
    required List<TimingModel> timings,
    required bool status,
  }) async {
    try {
      if (!serialPort.isOpen) {
        serialPort.close();
      }
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
        status ? CoreUtils.hexToDouble('FFFD') : CoreUtils.hexToDouble('FFFE'),
      ];

      final valueSend = CoreUtils.listDoubleToHexadecimal(listDouble);
      log('ValueSend: $valueSend');

      for (int i = 0; i < 107; i++) {
        Future.delayed(Duration(milliseconds: 50 * i), () {
          final bytesData =
              CoreUtils.hexaToBytes(valueSend.substring(i * 36, (i + 1) * 36));
          final result = serialPort.write(bytesData);

          log('Result: $result');
        });
      }
      Future.delayed(const Duration(milliseconds: 50 * 107), () {
        final bytesData = CoreUtils.hexaToBytes(
            valueSend.substring(107 * 36, (107) * 36 + 4));
        final result = serialPort.write(bytesData);

        log('Result: $result');
      });
      await Future.delayed(const Duration(milliseconds: 50 * 109), () {
        log('Stream is closed');
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

  @override
  Future<List<dynamic>> getDataFromECU({
    required SerialPort serialPort,
  }) async {
    try {
      if (!serialPort.isOpen) {
        serialPort.close();
      }

      SerialPortReader serialPortReader =
          SerialPortReader(serialPort, timeout: 10000);

      Stream upcomingData = serialPortReader.stream.map(
        (data) => data,
      );

      List<TimingModel> timings = [];
      List<TPSModel> tpss = [];
      List<RPMModel> rpms = [];

      // String upcomingDataStringDummy = '';
      // String timingsListDummy = "";
      // String tpssListDummy = "";
      // String rpmsListDummy = "";
      // for (int i = 0; i < 100; i++) {
      //   timingsListDummy += CoreUtils.intToHex(i);
      // }
      // for (int i = 0; i < 800; i++) {
      //   timingsListDummy += "FFFF";
      // }

      // for (int i = 0; i < 10; i++) {
      //   tpssListDummy += CoreUtils.intToHex(i);
      //   rpmsListDummy += CoreUtils.intToHex(i * 100);
      // }

      // for (int i = 0; i < 20; i++) {
      //   tpssListDummy += "FFFF";
      //   rpmsListDummy += "FFFF";
      // }

      // upcomingDataStringDummy =
      //     "FFFA${tpssListDummy}FFFB${rpmsListDummy}FFFC$timingsListDummy";

      String upcomingDataString = '';
      String timingsList = "";
      String tpssList = "";
      String rpmsList = "";

      String mod = "";
      String char = "";
      String value = "";

      upcomingData.listen((event) {
        upcomingDataString += String.fromCharCodes(event);
        log(upcomingDataString);
        if (upcomingDataString.length == 3856) {
          serialPortReader.close();
          serialPort.close();
        }
      });

      // upcomingData.forEach((data) {
      //   log(String.fromCharCodes(data));

      //   try {
      //     String input = String.fromCharCodes(data);
      //     if (input.length <= 16) {
      //       input = mod + input;
      //       mod = '';
      //       for (int i = 0; i < input.length; i++) {
      //         char = input[i];
      //         if (value.length < 16) {
      //           value += char;
      //         } else {
      //           mod += char;
      //         }
      //       }
      //     }
      //     if (value.length == 16 && CoreUtils.isHexadecimal(value)) {
      //       log(value);
      //       value = '';
      //     }
      //     if (upcomingDataString.length == 3856) {
      //       log('upcomingDataString: $upcomingDataString');
      //     }
      //   } catch (e) {
      //     throw PortException(message: e.toString());
      //   }
      // });

      await Future.delayed(const Duration(seconds: 20), () {
        log('Stream is closed');

        // upcomingDataString = upcomingDataStringDummy;

        // tpssList = upcomingDataString.substring(4, 124);
        // rpmsList = upcomingDataString.substring(128, 248);
        // timingsList = upcomingDataString.substring(252, 3852);
        // timings = List.generate(
        //   900 - CoreUtils.countOccurrences(timingsList, "FFFF"),
        //   (index) => const TimingModel.empty(),
        // );
        // tpss = List.generate(
        //   30 - CoreUtils.countOccurrences(tpssList, "FFFF"),
        //   (index) => const TPSModel.empty(),
        // );
        // rpms = List.generate(
        //   30 - CoreUtils.countOccurrences(rpmsList, "FFFF"),
        //   (index) => const RPMModel.empty(),
        // );
      });

      return [
        timings,
        tpss,
        rpms,
      ];
    } on PortException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw PortException(message: e.toString());
    }
  }
}
