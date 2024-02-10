import 'dart:async';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
// import 'package:serial_port_win32/serial_port_win32.dart';

import '../../../../core/errors/exceptions.dart';

abstract class HomePortDataSource {
  const HomePortDataSource();

  Stream<dynamic> getPortsValue({
    required String port,
    required StreamController<dynamic> controllerDataSource,
  });

  Future<List<String>> getPorts();
}

class HomePortDataSourceImpl implements HomePortDataSource {
  const HomePortDataSourceImpl();

  @override
  Stream<dynamic> getPortsValue({
    required String port,
    required StreamController<dynamic> controllerDataSource,
  }) async* {
    try {
      final SerialPortConfig cfg = SerialPortConfig();
      cfg.baudRate = 9600;
      cfg.bits = 16;
      SerialPort serialPort = SerialPort('/dev/cu.usbserial-0001');
      serialPort.config = cfg;
      serialPort.openRead();

      SerialPortReader reader = SerialPortReader(serialPort, timeout: 10000);

      Stream upcomingData = reader.stream.map(
        (data) => data,
      );

      String res = '';
      String type = '';
      List<double> portsValues = [];
      upcomingData.listen((data) {
        String char = String.fromCharCodes(data);
        if (char == 'R') {
          type = 'R';
        } else if (char == 'T' && portsValues.isNotEmpty) {
          type = 'T';
        } else if (char != '\n' && type != '' && char != 'R' && char != 'T') {
          res += char;
        } else if (char == '\n') {
          res = res.trim();
          if (type == 'R' && portsValues.isEmpty) {
            portsValues
                .add(double.tryParse(res) ?? 0); // Handling parsing error
          } else if (type == 'T' && portsValues.length == 1) {
            portsValues
                .add(double.tryParse(res) ?? 0); // Handling parsing error
            controllerDataSource.add(List<double>.from(portsValues));
            portsValues.clear();
          }
          print('type: $type, res: $res');
          type = '';
          res = '';
        }
      }, onError: (e, s) {
        debugPrintStack(stackTrace: s);
        controllerDataSource.add(PortException(message: e.toString()));
      }, onDone: () {
        controllerDataSource.close();
      }, cancelOnError: true);
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
      print('Ports: $ports');
      //  /dev/cu.usbserial-AR0JRHZS]
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
}
