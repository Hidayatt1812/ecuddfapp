import 'package:ddfapp/core/utils/core_utils.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:serial_port_win32/serial_port_win32.dart';
// import 'package:serial_port_win32/serial_port_win32.dart';

import '../../../../core/errors/exceptions.dart';

abstract class HomePortDataSource {
  const HomePortDataSource();

  Stream<List<double>> getPortsValue({
    required String port,
  });

  Future<List<String>> getPorts();
}

class HomePortDataSourceImpl implements HomePortDataSource {
  const HomePortDataSourceImpl();

  @override
  Stream<List<double>> getPortsValue({
    required String port,
  }) async* {
    try {
      SerialPort serialPort = SerialPort(port);
      print('Serial Port: $serialPort');
      // SerialPort serialPort = SerialPort('/dev/cu.usbserial-AR0JRHZS');
      serialPort.open();

      // if (!serialPort.isOpen) {
      //   throw const PortException(message: 'Port is not open');
      // }

      // serialPort.readBytesOnListen(4, (value) async* {
      //   List<double> portsValues = CoreUtils.bytesToDouble(value);

      //   yield portsValues;
      // });

      // final result = serialPort.read(4);
      List<double> portsValues = [];
      serialPort.readBytesOnListen(4, (value) {
        portsValues = CoreUtils.bytesToDouble(value);

        // try {
        //   sC.readRPM.value = intList[0];
        //   sC.readTPS.value = intList[1];
        //   sC.readMAP.value = intList[2];
        // } catch (e) {
        //   if (kDebugMode) {
        //     print("waiting data...");
        //   }
        // }
      });

      // List<double> portsValues = CoreUtils.bytesToDouble(result);
      // List<double> portsValues = [0, 0, 0, 0];

      yield portsValues;
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
      final ports = SerialPort.getAvailablePorts();
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
