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
              child: Text(e.toString()),
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

  SerialPort? _serialPort;

  SerialPort? get serialPort => _serialPort;

  void setSerialPort() {
    final SerialPortConfig cfg = SerialPortConfig();
    cfg.baudRate = 9600;
    cfg.bits = 256;
    try {
      _serialPort = SerialPort(selectedPort);
      _serialPort!.config = cfg;
      _serialPort!.openReadWrite();
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
      _serialPort!.dispose();
      _serialPort = null;
    }
    notifyListeners();
  }
}
