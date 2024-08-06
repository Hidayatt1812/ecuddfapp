import 'package:fluent_ui/fluent_ui.dart';

import '../../../../src/home/domain/entities/ecu.dart';

class ECUProvider extends ChangeNotifier {
  ECU _ecu = const ECU.empty();

  ECU get ecu => _ecu;

  void updateECU(ECU ecu) {
    _ecu = ecu;

    Future.delayed(Duration.zero, notifyListeners);
  }
}
