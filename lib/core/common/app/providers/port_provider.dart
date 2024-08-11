import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class PortProvider extends ChangeNotifier {
  List<String> _ports = ['None'];

  List<String> get ports => _ports;

  void initPorts(List<String> ports) {
    if (_ports != ports) {
      _ports = ports;
      _ports.add('None');
    }

    initComboBoxItems();
    notifyListeners();
  }

  List<ComboBoxItem<String>> _comboBoxItems = [];

  List<ComboBoxItem<String>> get comboBoxItems => _comboBoxItems;

  void initComboBoxItems() {
    _comboBoxItems = _ports
        .map((e) => ComboBoxItem(
              value: e.toString(),
              child: Tooltip(
                displayHorizontally: true,
                message: e.toString(),
                child: Text(
                  e.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ))
        .toList();
    notifyListeners();
  }

  String _selectedPort = "None";

  String get selectedPort => _selectedPort;

  void setSelectedPort(String value) {
    if (_selectedPort != value && _ports.contains(value)) {
      _selectedPort = value;
      notifyListeners();
    }
  }

  bool checkPort(String port) {
    return _ports.contains(port);
  }

  bool _isStreaming = false;

  bool get isStreaming => _isStreaming;

  void setIsStreaming(bool value) {
    _isStreaming = value;

    notifyListeners();
  }

  SerialPortReader? _serialPortReader;

  SerialPortReader? get serialPortReader => _serialPortReader;

  void setSerialPortReader() {
    setIsStreaming(true);
    setSerialPort();
    try {
      _serialPortReader = SerialPortReader(_serialPort!, timeout: 10000);
    } catch (e) {
      debugPrintStack(label: e.toString());
    }
    notifyListeners();
  }

  SerialPortConfig? _cfg;

  SerialPortConfig? get cfg => _cfg;

  void setSerialPortConfig() {
    _cfg = SerialPortConfig();
    if (_cfg != null) {
      // _cfg!.baudRate = 9600;
      // _cfg!.bits = 256;
      // _cfg!.dtr = 1;
      _cfg!.baudRate = 115200;
      _cfg!.bits = 8;
      _cfg!.parity = SerialPortParity.none;
      _cfg!.stopBits = 1;
      _cfg!.xonXoff = 0;
      _cfg!.rts = 1;
      _cfg!.cts = 0;
      _cfg!.dsr = 0;
      _cfg!.dtr = 1;
    }
    notifyListeners();
  }

  void disposeSerialPortConfig() {
    if (cfg != null) {
      _cfg = null;
    }
  }

  SerialPort? _serialPort;

  SerialPort? get serialPort => _serialPort;

  void setSerialPort() {
    setSerialPortConfig();
    try {
      _serialPort = SerialPort(selectedPort);
      _serialPort!.openReadWrite();
      _serialPort!.config = cfg!;
      _cfg!.dispose();
    } catch (e) {
      debugPrintStack(label: e.toString());
    }
    notifyListeners();
  }

  void closeSerialPortReader() {
    if (_serialPortReader != null) {
      _serialPortReader!.close();
      _serialPortReader = null;
    }
    closeSerialPort();
    setIsStreaming(false);
    notifyListeners();
  }

  void closeSerialPort() {
    if (_serialPort != null) {
      _serialPort!.close();
      // _serialPort!.dispose();
      _serialPort = null;
    }
    // disposeSerialPortConfig();
    notifyListeners();
  }
}
