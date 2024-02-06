import 'package:fluent_ui/fluent_ui.dart';

class PortProvider extends ChangeNotifier {
  List<String> _ports = [
    "COM1",
    "COM2",
    "COM3",
    "COM4",
    "COM5",
    "COM6",
    "COM7",
  ];

  List<String> get ports => _ports;

  void initPorts(List<String> ports) {
    if (_ports != ports) {
      _ports = ports;

      Future.delayed(Duration.zero, notifyListeners);
    }
  }

  String _selectedPort = "COM1";

  String get selectedPort => _selectedPort;

  void setSelectedPort(String value) {
    if (_selectedPort != value) {
      _selectedPort = value;

      Future.delayed(Duration.zero, notifyListeners);
    }
  }
}
