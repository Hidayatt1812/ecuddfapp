import 'dart:async';
import 'dart:developer';
import 'package:ddfapp/core/utils/core_utils.dart';
import 'package:ddfapp/src/home/data/models/ecu_model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/rpm_model.dart';
import '../models/timing_model.dart';
import '../models/tps_model.dart';

abstract class HomePortDataSource {
  const HomePortDataSource();

  Stream<ECUModel> getTPSRPMLinesValue({
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
    required bool status,
  });

  Future<List<dynamic>> getDataFromECU({
    required SerialPort serialPort,
  });
}

class HomePortDataSourceImpl implements HomePortDataSource {
  const HomePortDataSourceImpl();

  @override
  Stream<ECUModel> getTPSRPMLinesValue({
    required SerialPortReader serialPortReader,
  }) async* {
    try {
      final StreamController<ECUModel> controllerDataSource =
          StreamController<ECUModel>();

      Stream upcomingData = serialPortReader.stream.map(
        (data) => data,
      );

      String mod = '';
      String char = '';
      String value = '';
      // List<double> portsValues = [];
      ECUModel ecuModel = const ECUModel.empty();
      StreamSubscription subscription = upcomingData.listen(
        (data) {
          // log(String.fromCharCodes(data));
          try {
            String input = String.fromCharCodes(data);
            // print("1:$input");
            input = CoreUtils.removeHexaChar(input);
            // print("2:$input");

            if (input.length <= 84) {
              input = mod + input;
              mod = '';
              for (int i = 0; i < input.length; i++) {
                char = input[i];
                if (value.length < 84) {
                  value += char;
                } else {
                  mod += char;
                }
              }
            }

            if (value.contains("FFFA")) {
              value = value.substring(value.indexOf("FFFA"));
              log(value);
            }
            // FFFA-XXXX-FFFB-XXXX-FFFM-XXXX-FFTA-XXXX-FFTB-XXXX-FFTC-XXXX-FFIA-XXXX-FFIB-XXXX-FFIC-XXXX-FFID-XXXX-FFFD
            if (value.length > 4 && value.substring(0, 4) != "FFFA") {
              value = "";
              mod = "";
            }
            if (value.length > 12 && value.substring(8, 12) != "FFFB") {
              value = "";
              mod = "";
            }
            if (value.length > 20 && value.substring(16, 20) != "FFFM") {
              value = "";
              mod = "";
            }
            if (value.length > 28 && value.substring(24, 28) != "FFTA") {
              value = "";
              mod = "";
            }
            if (value.length > 36 && value.substring(32, 36) != "FFTB") {
              value = "";
              mod = "";
            }
            if (value.length > 44 && value.substring(40, 44) != "FFTC") {
              value = "";
              mod = "";
            }
            if (value.length > 52 && value.substring(48, 52) != "FFIA") {
              value = "";
              mod = "";
            }
            if (value.length > 60 && value.substring(56, 60) != "FFIB") {
              value = "";
              mod = "";
            }
            if (value.length > 68 && value.substring(64, 68) != "FFIC") {
              value = "";
              mod = "";
            }
            if (value.length > 76 && value.substring(72, 76) != "FFID") {
              value = "";
              mod = "";
            }
            if (value.length == 84 &&
                (value.substring(80, 84) != "FFFD" &&
                    value.substring(80, 84) != "FFFE")) {
              value = "";
              mod = "";
            }
            if (value.length == 84 && CoreUtils.isECUDataFormat(value)) {
              log(value);
              // portsValues.add((double.tryParse(
              //           CoreUtils.hexToDoubleString(value.substring(4, 8)),
              //         ) ??
              //         0) /
              //     4096 *
              //     3.3);
              // portsValues.add(double.tryParse(
              //         CoreUtils.hexToDoubleString(value.substring(12, 16))) ??
              //     0);
              ecuModel = ecuModel.copyWith(
                tps: (double.tryParse(CoreUtils.hexToDoubleString(
                            value.substring(4, 8))) ??
                        0) /
                    4096 *
                    3.3,
                rpm: (double.tryParse(
                      CoreUtils.hexToDoubleString(value.substring(12, 16)),
                    ) ??
                    0),
                map: double.tryParse(
                        CoreUtils.hexToDoubleString(value.substring(20, 24))) ??
                    0,
                temp1: double.tryParse(
                        CoreUtils.hexToDoubleString(value.substring(28, 32))) ??
                    0,
                temp2: double.tryParse(
                        CoreUtils.hexToDoubleString(value.substring(36, 40))) ??
                    0,
                temp3: double.tryParse(
                        CoreUtils.hexToDoubleString(value.substring(44, 48))) ??
                    0,
                timing1: (double.tryParse(CoreUtils.hexToDoubleString(
                            value.substring(52, 56))) ??
                        0) /
                    100,
                timing2: (double.tryParse(CoreUtils.hexToDoubleString(
                            value.substring(60, 64))) ??
                        0) /
                    100,
                timing3: (double.tryParse(CoreUtils.hexToDoubleString(
                            value.substring(68, 72))) ??
                        0) /
                    100,
                timing4: (double.tryParse(CoreUtils.hexToDoubleString(
                            value.substring(76, 80))) ??
                        0) /
                    100,
                powerStatus: value.substring(80, 84) == "FFFD",
              );
              log(ecuModel.toString());
              controllerDataSource.add(ecuModel);
              // portsValues.clear();
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
            //     log('Values: $portsValues');
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
          if (!controllerDataSource.isClosed) {
            controllerDataSource.close();
          }
        },
        onDone: () {
          if (!controllerDataSource.isClosed) {
            controllerDataSource.close();
          }
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
      // if (!serialPort.isOpen) {
      //   serialPort.close();
      // }

      List<double> listDouble = [
        CoreUtils.hexToDouble('FFFA'),
        ...tpss.map((e) => e.value * 4096 / 3.3).toList(),
        for (int i = tpss.length; i < 30; i++) CoreUtils.hexToDouble('FFFF'),
        CoreUtils.hexToDouble('FFFB'),
        ...rpms.map((e) => e.value).toList(),
        for (int i = rpms.length; i < 30; i++) CoreUtils.hexToDouble('FFFF'),
        CoreUtils.hexToDouble('FFFC'),
        ...timings.map((e) => e.value * 100).toList(),
        for (int i = timings.length; i < 900; i++)
          CoreUtils.hexToDouble('FFFF'),
        status ? CoreUtils.hexToDouble('FFFD') : CoreUtils.hexToDouble('FFFE'),
      ];

      final valueSend = "FFFW${CoreUtils.listDoubleToHexadecimal(listDouble)}";
      log('value.lenght = ${valueSend.length}');
      log(valueSend);

      final bytesData = CoreUtils.hexaToBytes(valueSend);
      final result = serialPort.write(bytesData, timeout: 0);
      log('Result: $result');

      // for (int i = 0; i < 107; i++) {
      //   await Future.delayed(const Duration(milliseconds: 30), () {
      //     final bytesData =
      //         CoreUtils.hexaToBytes(valueSend.substring(i * 36, (i + 1) * 36));
      //     final result = serialPort.write(bytesData);

      //     log('Result: $result');
      //   });
      // }
      // await Future.delayed(const Duration(milliseconds: 30), () {
      //   final bytesData = CoreUtils.hexaToBytes(
      //       valueSend.substring(107 * 36, (107) * 36 + 8));
      //   final result = serialPort.write(bytesData);

      //   log('Result: $result');
      // });
      await Future.delayed(const Duration(milliseconds: 5000), () {
        log('Stream is closed');
        serialPort.close();
        // serialPort.dispose();
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
      if (!serialPort.isOpen) {
        serialPort.close();
      }
      String valueSend = status ? "FFFD" : "FFFE";
      for (int i = 0; i < 964; i++) {
        valueSend += "FFFF";
      }

      log('value.lenght = ${valueSend.length}');

      final bytesData = CoreUtils.hexaToBytes(valueSend);
      final result = serialPort.write(bytesData, timeout: 0);
      log('Result: $result');

      await Future.delayed(const Duration(milliseconds: 5000), () {
        log('Stream is closed');
        serialPort.close();
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
          SerialPortReader(serialPort, timeout: 0);

      Stream upcomingData = serialPortReader.stream.map(
        (data) => data,
      );
      String upcomingDataString = '';
      upcomingData.listen((event) {
        upcomingDataString += String.fromCharCodes(event);
        // log(upcomingDataString);
        if (upcomingDataString.length > 8 &&
            upcomingDataString.contains("FFFW")) {
          upcomingDataString =
              upcomingDataString.substring(upcomingDataString.indexOf("FFFW"));
          if (upcomingDataString.length > 3860) {
            serialPortReader.close();
            serialPort.close();
          }
        } else {
          upcomingDataString = '';
        }
      });

      String valueSend = "FFFR";
      for (int i = 0; i < 964; i++) {
        valueSend += "FFFF";
      }

      log('value.lenght = ${valueSend.length}');

      final bytesData = CoreUtils.hexaToBytes(valueSend);
      final result = serialPort.write(bytesData, timeout: 0);
      log('Result: $result');

      await Future.delayed(const Duration(milliseconds: 4000), () {
        log('Stream is closed');
      });

      List<TimingModel> timings = [];
      List<TPSModel> tpss = [];
      List<RPMModel> rpms = [];
      log('Stream is open');

      while (upcomingDataString.length < 3860) {
        log(upcomingDataString.length.toString());
        await Future.delayed(const Duration(milliseconds: 100));
      }

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

      // cut upcomingDataString to have only 3860 characters

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
      //     if (value.length == 16 && CoreUtils.isECUDataFormat(value)) {
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

      // await Future.delayed(const Duration(seconds: 10), () {
      //   log('Stream is closed');
      //   log('length: ${upcomingDataString.length}');
      //   log('upcomingDataString: $upcomingDataString');

      //   // upcomingDataString = upcomingDataStringDummy;
      // });
      upcomingDataString = upcomingDataString.substring(0, 3860);
      if (upcomingDataString.length != 3860) {
        throw const PortException(message: 'Data is not complete');
      }

      String tpssList = upcomingDataString.substring(8, 128);
      String rpmsList = upcomingDataString.substring(132, 252);
      String timingsList = upcomingDataString.substring(256, 3856);
      tpssList = tpssList.replaceAll('FFFF', '');

      rpmsList = rpmsList.replaceAll('FFFF', '');

      timingsList = timingsList.replaceAll('FFFF', '');
      for (int i = 0; i < tpssList.length / 4; i++) {
        tpss.add(
          TPSModel(
            id: i,
            isFirst: i == 0,
            isLast: i == tpssList.length / 4 - 1,
            value: CoreUtils.hexToDouble(tpssList.substring(i * 4, i * 4 + 4)) *
                3.3 /
                4096,
            prevValue: i == 0
                ? null
                : CoreUtils.hexToDouble(tpssList.substring(i * 4 - 4, i * 4)) *
                    3.3 /
                    4096,
            nextValue: i == tpssList.length / 4 - 1
                ? null
                : CoreUtils.hexToDouble(
                        tpssList.substring(i * 4 + 4, i * 4 + 8)) *
                    3.3 /
                    4096,
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
    } on PortException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw PortException(message: e.toString());
    }
  }
}
