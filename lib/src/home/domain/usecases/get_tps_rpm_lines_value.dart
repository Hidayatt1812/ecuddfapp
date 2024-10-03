import 'package:flutter_libserialport/flutter_libserialport.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/ecu.dart';
import '../repository/home_repository.dart';

class GetTPSRPMLinesValue
    implements UsecaseWithParamsStream<ECU, SerialPortReader> {
  const GetTPSRPMLinesValue(this._repository);

  final HomeRepository _repository;

  @override
  ResultStream<ECU> call(SerialPortReader serialPortReader) =>
      _repository.getTPSRPMLinesValue(
        serialPortReader: serialPortReader,
      );
}
