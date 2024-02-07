import 'package:ddfapp/core/utils/core_utils.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
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
      serialPort.open(mode: SerialPortMode.read);

      if (!serialPort.isOpen) {
        throw const PortException(message: 'Port is not open');
      }

      // serialPort.readBytesOnListen(4, (value) async* {
      //   List<double> portsValues = CoreUtils.bytesToDouble(value);

      //   yield portsValues;
      // });

      final result = serialPort.read(4);

      List<double> portsValues = CoreUtils.bytesToDouble(result);

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
}
