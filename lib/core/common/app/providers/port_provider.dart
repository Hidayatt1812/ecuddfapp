import 'package:fluent_ui/fluent_ui.dart';

class PortProvider extends ChangeNotifier {
  List<String> _ports = ['None'];

  List<String> get ports => _ports;

  void initPorts(List<String> ports) {
    if (_ports != ports) {
      _ports = ports;
      _ports.add('None');

      Future.delayed(Duration.zero, notifyListeners);
    }
  }

  String _selectedPort = "None";

  String get selectedPort => _selectedPort;

  void setSelectedPort(String value) {
    if (_selectedPort != value && _ports.contains(value)) {
      _selectedPort = value;
      // ports.add(value);

      Future.delayed(Duration.zero, notifyListeners);
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
}
